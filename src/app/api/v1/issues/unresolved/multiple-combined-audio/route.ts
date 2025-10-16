import { getConnection } from "@/lib/db";
import { unformatSQL } from "@/lib/query";


export type InterviewIssue = {
    interview_name: string;
    interview_type: string;
    subject_id: string;
    study_id: string;
    parts_count: number;
};

/**
 * Handles the GET request to fetch interviews from the database.
 *
 * @param {Request} request - The incoming request object.
 * @returns {Promise<Response>} - A promise that resolves to a Response object containing the fetched interviews in JSON format.
 *
 */
export async function GET(request: Request): Promise<Response> {
    const connection = getConnection();
    const url = new URL(request.url);
    const limit = url.searchParams.get('limit') || 5;
    const offset = url.searchParams.get('offset') || 0;

    const baseQuery = `
    WITH interview_file_counts AS (
        SELECT
            interview_name,
            COUNT(*) as file_count
        FROM public.interview_files
        LEFT JOIN public.interview_parts USING (interview_path)
        LEFT JOIN public.interviews USING (interview_name)
        WHERE public.interview_files.ignored IS FALSE AND
            public.interview_parts.is_duplicate IS FALSE AND
            public.interview_parts.is_primary IS TRUE AND
            public.interview_files.interview_file_tags LIKE '%audio%' AND
            public.interview_files.interview_file_tags LIKE '%combined%'
        GROUP BY interview_name
    )
    SELECT
        i.interview_name,
        public.interviews.interview_type,
        public.interviews.subject_id,
        public.interviews.study_id,
        i.file_count
    FROM public.interview_files
    LEFT JOIN public.interview_parts USING (interview_path)
    LEFT JOIN public.interviews USING (interview_name)
    JOIN interview_file_counts i ON i.interview_name = public.interviews.interview_name
    WHERE public.interview_files.ignored IS FALSE AND
        public.interview_parts.is_duplicate IS FALSE AND
        public.interview_parts.is_primary IS TRUE AND
        public.interview_files.interview_file_tags LIKE '%audio%' AND
        public.interview_files.interview_file_tags LIKE '%combined%' AND
        i.file_count != 1  -- Exclude interviews with exactly one audio file
    `;

    const countQuery = `SELECT COUNT(*) FROM (${baseQuery}) AS total_count`;
    const countResult = await connection.query(countQuery);
    const totalRows = countResult.rows[0].count;

    const limitedQuery = `${baseQuery} LIMIT ${limit} OFFSET ${offset}`;
    const { rows } = await connection.query(limitedQuery);

    const metadata = {
        query: unformatSQL(limitedQuery),
        totalRows,
        limit,
        offset,
    };

    return new Response(JSON.stringify({ metadata, rows }), {
        headers: {
            'Content-Type': 'application/json',
        },
    });
}
