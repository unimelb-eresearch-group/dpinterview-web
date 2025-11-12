import { getConnection } from "@/lib/db";

import { DbExpectedInterview } from "@/lib/types/interview";

export class ExpectedInterviews {
    static async getBySubject(study_id: string, subject_id: string): Promise<DbExpectedInterview[]> {
        const connection = getConnection();
        const result = await connection.query<DbExpectedInterview>(
            `
            SELECT *
            FROM expected_interviews
            WHERE study_id = $1 AND
                subject_id = $2
            ORDER BY expected_interview_day ASC
            `,
            [study_id, subject_id]
        );
        
        if (result.rows.length === 0) {
            return [];
        }

        const rows = result.rows as DbExpectedInterview[];
        return rows;
    }
}
