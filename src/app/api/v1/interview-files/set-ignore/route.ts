import { InterviewFiles } from "@/lib/models/InterviewFiles";

export async function POST(request: Request): Promise<Response> {
    try {
        const body = await request.json();
        const { file_path, ignored, interview_name } = body;
        if (!file_path || typeof ignored !== "boolean") {
            return new Response(JSON.stringify({ error: "Missing file_path or ignored parameter" }), {
                status: 400,
                headers: { "Content-Type": "application/json" },
            });
        }

        // Record dashboard action
        const action = ignored ? "mark_ignored" : "unmark_ignored";
        try {
            const { DashboardActions } = await import("@/lib/models/DashboardActions");
            await DashboardActions.recordAction(
                interview_name || "unknown",
                action,
                file_path,
                "file_path"
            );
        } catch (e) {
            // If DashboardActions fails, continue but log error
            console.error("Failed to record dashboard action", e);
        }

        await InterviewFiles.setIgnoreFile(file_path, ignored);

        return new Response(JSON.stringify({ success: true }), {
            status: 200,
            headers: { "Content-Type": "application/json" },
        });
    } catch (error: any) {
        return new Response(JSON.stringify({ error: error.message || "Unknown error" }), {
            status: 500,
            headers: { "Content-Type": "application/json" },
        });
    }
}
