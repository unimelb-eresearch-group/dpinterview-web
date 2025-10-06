// qc_target_id text NOT NULL,
// qc_target_type text NOT NULL,
// qc_data jsonb NOT NULL,
// qc_user_id text NOT NULL,
// qc_timestamp timestamp NOT NULL,
export type DbManualQc = {
    qc_target_id: string;
    qc_target_type: string;
    qc_data: {
        hasNoIssues: boolean;
        identifiedIssues: string[];
        uploadToNda?: boolean;
        comments?: string;
    }
    qc_user_id: string;
    qc_timestamp: string;
}

export type QcFormSchema = {
    inteviewName: string;
    hasNoIssues: boolean;
    identifiedIssues: string[];
    uploadToNda?: boolean;
    comments?: string;
    qcUser: string;
    qcDatetime?: Date;  // Ignored
}