import { NextResponse } from 'next/server';

import { PdfReports } from "@/lib/models/PdfReports";
import {makeFileUrl} from "@/lib/utils";

export async function GET(
    request: Request,
    props: { params: Promise<{ interview_name: string }> }
): Promise<Response> {
    const params = await props.params;
    const interview_name = params.interview_name;

    if (!interview_name) {
        return NextResponse.json({ error: 'Missing interview_name parameter' }, { status: 400 });
    }

    const pdfReportData = await PdfReports.get(interview_name);

    if (!pdfReportData) {
        return NextResponse.json({ error: 'PDF report not found' }, { status: 404 });
    }

    // Redirect to the Report file URL
    // http://localhost:45000/payload=[<path>]

    const redirectUrl = makeFileUrl(pdfReportData.pr_path);
    return NextResponse.redirect(redirectUrl);
}