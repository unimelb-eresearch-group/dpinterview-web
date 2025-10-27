import { InterviewParts } from "@/lib/models/InterviewParts";
import { DashboardActions } from "@/lib/models/DashboardActions";

export async function GET(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const interview_name = url.searchParams.get('interview_name');

    if (!interview_name) {
        return new Response(JSON.stringify({ error: 'Missing interview_name parameter' }), {
            status: 400,
            headers: {
                'Content-Type': 'application/json',
            },
        });
    }

    const interviewParts = await InterviewParts.get(interview_name);

    if (!interviewParts || interviewParts.length === 0) {
        return new Response(JSON.stringify({ error: 'Interview not found' }), {
            status: 404,
            headers: {
                'Content-Type': 'application/json',
            },
        });
    }

    return new Response(JSON.stringify(interviewParts), {
        headers: {
            'Content-Type': 'application/json',
        },
    });
}

export async function POST(request: Request): Promise<Response> {
    // const url = new URL(request.url);
    // const interview_path = url.searchParams.get('interview_path');

    // if (!interview_path) {
    //     return new Response(JSON.stringify({ error: 'Missing interview_path parameter' }), {
    //         status: 400,
    //         headers: {
    //             'Content-Type': 'application/json',
    //         },
    //     });
    // }

    const body = await request.json();
    const interview_path: string = body.interview_path;
    const interview_name: string = body.interview_name;

    if (body.is_primary === undefined && body.is_duplicate === undefined) {
        return new Response(
            JSON.stringify({
                error: 'Missing is_primary or is_duplicate parameter' 
            }),
            {
                status: 400,
                headers: {
                    'Content-Type': 'application/json',
                },
        });
    }

    if (body.is_primary !== undefined) {
        const action = body.is_primary ? "mark_primary" : "unmark_primary";
        await DashboardActions.recordAction(
            interview_name,
            action,
            interview_path,
            "interview_path"
        );
        await InterviewParts.setPrimary(interview_path, body.is_primary);
    }

    if (body.is_duplicate !== undefined) {
        const action = body.is_duplicate ? "mark_duplicate" : "unmark_duplicate";
        await DashboardActions.recordAction(
            interview_name,
            action,
            interview_path,
            "interview_path"
        );
        await InterviewParts.setDuplicate(interview_path, body.is_duplicate);
    }

    return new Response(JSON.stringify({ success: true }), {
        headers: {
            'Content-Type': 'application/json',
        },
    });
}