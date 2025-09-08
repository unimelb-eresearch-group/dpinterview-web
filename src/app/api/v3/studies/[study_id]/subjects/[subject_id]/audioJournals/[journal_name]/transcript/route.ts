import {NextRequest, NextResponse} from 'next/server';

import { TranscriptFiles } from '@/lib/models/TranscriptFiles';

import {makeFilePath} from "@/lib/utils";
import {NextURL} from "next/dist/server/web/next-url";

export async function GET(
    request: NextRequest,
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

    const redirectPath = makeFilePath(transcriptFile);
    const redirectUrl = new NextURL(redirectPath,request.nextUrl);
    return NextResponse.redirect(redirectUrl);
}
