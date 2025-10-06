import { getConnection } from "@/lib/db";
import { unformatSQL } from "@/lib/query";

/**
 * Handles the GET request to fetch interviews pending QC from the database.
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
    SELECT DISTINCT
        i.*,
        mqc.qc_timestamp
    FROM video_quick_qc AS vq
    LEFT JOIN decrypted_files AS df ON vq.video_path = df.destination_path
    LEFT JOIN interview_files AS iff ON df.source_path = iff.interview_file
    LEFT JOIN interview_parts AS ip USING(interview_path)
    LEFT JOIN interviews AS i USING (interview_name)
    LEFT JOIN manual_qc AS mqc ON ip.interview_name = mqc.qc_target_id AND mqc.qc_target_type = 'interview'
    WHERE mqc.qc_target_id IS NOT NULL
    ORDER BY mqc.qc_timestamp DESC
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
