import { NextResponse } from 'next/server';

import { TranscriptFiles } from '@/lib/models/TranscriptFiles';

import {makeFileUrl} from "@/lib/utils";

export async function GET(
    request: Request,
    props: { params: Promise<{ study_id: string, subject_id: string, journal_name: string }> }
): Promise<Response> {
    const params = await props.params;
    const { study_id, subject_id, journal_name } = params;

    if (!study_id || !subject_id || !journal_name) {
        return new Response(JSON.stringify({ error: 'Missing study_id or subject_id or journal_name parameter' }), {
            status: 400,
            headers: {
                'Content-Type': 'application/json',
            },
        });
    }

    const transcriptFile = await TranscriptFiles.getTranscriptFile(journal_name);

    if (!transcriptFile) {
        return NextResponse.json({ error: 'Transcript file not found' }, { status: 404 });
    }

    // Redirect to the transcript file URL
    // http://localhost:45000/payload=[<path>]

    const redirectUrl = makeFileUrl(transcriptFile);
    return NextResponse.redirect(redirectUrl);
}
