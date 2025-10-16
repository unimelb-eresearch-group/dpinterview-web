import { getConnection } from "@/lib/db";
import { unformatSQL } from "@/lib/query";

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
    const studyId = url.searchParams.get('study_id');
    const subjectId = url.searchParams.get('subject_id');
    const limit = url.searchParams.get('limit') || 5;
    const offset = url.searchParams.get('offset') || 0;

    let baseQuery = "SELECT * FROM audio_journals";
    const params: any[] = [];
    let paramIndex = 1;

    if (studyId) {
        baseQuery += ` WHERE study_id = $${paramIndex++}`;
        params.push(studyId);
    }

    if (subjectId) {
        baseQuery += ` ${params.length ? 'AND' : 'WHERE'} subject_id = $${paramIndex++}`;
        params.push(subjectId);
    }

    baseQuery += ` ORDER BY aj_datetime DESC`;

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
