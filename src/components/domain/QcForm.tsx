import { useState } from "react"
import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import { z } from "zod"
import { toast } from "sonner";

import { Button } from "@/components/ui/button"
import {
    Form,
    FormControl,
    FormDescription,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from "@/components/ui/form"
import { Input } from "@/components/ui/input"
import { Checkbox } from "@/components/ui/checkbox"
import { useEffect } from "react";
import { DbManualQc } from "@/lib/types/manual_qc";

const formSchema = z.object({
    interviewName: z.string().min(1, { message: "Interview name is required" }),
    hasNoIssues: z.boolean(),
    uploadToNda: z.boolean().optional(),
    identifiedIssues: z.array(z.string()).optional(),
    comments: z.string().optional(),
    qcDatetime: z.string().optional(),  // Ignored
    qcUser: z.string().min(1, { message: "QC user is required" }),
}).refine(
    (data) => !data.hasNoIssues || (data.identifiedIssues?.length === 0),
    {
        message: "If no issues are identified, the identified issues field should be empty.",
        path: ["identifiedIssues"],
    }
).refine(
    (data) => !data.hasNoIssues || (data.identifiedIssues?.length === 0),
    {
        message: "If issues have been identified, the hasNoIssues field should be unchecked.",
        path: ["hasNoIssues"],
    }
)

export default function QcForm(
    props: {
        interviewName: string;
    }
) {
    const { interviewName } = props;
    const [ qcData, setQcData ] = useState<DbManualQc | null>(null);

    useEffect(() => {
        const fetchInterviewData = async () => {
            const response = await fetch(`/api/v2/interviews/${interviewName}/qc`);
            const data = await response.json();
            if (response.ok) {
                // If list, use first element
                if (Array.isArray(data) && data.length > 0) {
                    setQcData(data[0]);
                } else {
                    setQcData(data);
                }
                // console.log("Fetched interview QC data:", data);
            } else {
                toast.error("Failed to fetch interview QC data");
                // console.error("Error:", data);
            }
        }
        fetchInterviewData();
    }, [interviewName]);

    useEffect(() => {
        // console.log("QC data:", qcData);
        if (qcData && qcData.qc_data) {
            form.setValue("hasNoIssues", qcData.qc_data.hasNoIssues);
            form.setValue("identifiedIssues", qcData.qc_data.identifiedIssues || []);
            form.setValue("uploadToNda", qcData.qc_data.uploadToNda || false);
            form.setValue("comments", qcData.qc_data.comments || "");
            form.setValue("qcDatetime", qcData.qc_timestamp);
            form.setValue("qcUser", qcData.qc_user_id);
        }
    }, [qcData]);

    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            interviewName: interviewName,
            hasNoIssues: false,
            identifiedIssues: [],
            uploadToNda: false,
            comments: "",
            qcDatetime: new Date().toISOString(),
            qcUser: "",
        },
    })

    function handleFormSubmit(values: z.infer<typeof formSchema>) {
        const body = {
            ...values,
        }

        fetch(`/api/v2/interviews/${interviewName}/qc`, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(body),
        })
        .then((response) => {   
            if (!response.ok) {
                throw new Error("Network response was not ok");
            }
            return response.json();
        })
        .then(() => {
            toast.success("QC data added successfully");
        })
        .catch((error) => {
            toast.error("Failed to add QC data");
            console.error("Error:", error);
        });
    }

    return (
        <div className="container mx-auto p-4">
            {/* <Alert color="neutral" variant="soft">
                This page is under construction. Please check back later.
            </Alert> */}
            <Form {...form}>
                <form onSubmit={form.handleSubmit(handleFormSubmit)} className="space-y-8 max-w-2xl mx-auto">
                    {/* <div className="border rounded-lg p-6 bg-slate-50">
                        <h2 className="text-lg font-semibold mb-4 text-slate-800">Interview Information</h2>
                        <FormField
                            control={form.control}
                            name="interviewName"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Interview Name</FormLabel>
                                    <FormControl>
                                        <Input disabled placeholder="InterviewName" {...field} className="bg-white" />
                                    </FormControl>
                                    <FormDescription>
                                        This is the name of the interview.
                                    </FormDescription>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </div> */}

                    <div className="border rounded-lg p-6 bg-slate-50">
                        <h2 className="text-lg font-semibold mb-4 text-slate-800">Quality Assessment</h2>
                        <FormField
                            control={form.control}
                            name="hasNoIssues"
                            render={({ field }) => (
                                <FormItem className="mb-6 border-b pb-4">
                                    <div className="flex flex-row items-start space-x-3 space-y-0">
                                        <FormControl>
                                            <Checkbox
                                                checked={field.value}
                                                onCheckedChange={field.onChange}
                                                className="mt-1"
                                            />
                                        </FormControl>
                                        <div className="space-y-1 leading-none">
                                            <FormLabel className="text-base font-medium">
                                                No issues identified
                                            </FormLabel>
                                            <FormDescription>
                                                Check this only if the interview has no issues.
                                            </FormDescription>
                                        </div>
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <FormField
                            control={form.control}
                            name="identifiedIssues"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel className="text-base font-medium">Identified Issues</FormLabel>
                                    <FormDescription className="mb-2">
                                        Select all issues that apply to this interview.
                                    </FormDescription>
                                    <div className="grid gap-3 md:grid-cols-2">
                                        {[
                                            { value: "audio_quality", label: "Audio quality issues" },
                                            { value: "video_quality", label: "Video quality issues" },
                                            { value: "not_gallery_view", label: "Not in Zoom Gallery view" },
                                            { value: "participants_switched", label: "Interviewer / Subject switched" },
                                            { value: "wrong_orientation", label: "Wrong Video Orientation" },
                                            { value: "face_obstructed", label: "Face Obstructed" },
                                            { value: "bad_lighting", label: "Bad Lighting" },
                                            { value: "audio_sync", label: "Audio Out of Sync" },
                                            { value: "other", label: "Other" },
                                        ].map((issue) => (
                                            <div key={issue.value} className="flex items-center space-x-2 p-2 rounded border bg-white">
                                                {(() => {
                                                    const toggleIssue = () => {
                                                        const checked = !field.value?.includes(issue.value);
                                                        const updatedIssues = checked
                                                            ? [...(field.value || []), issue.value]
                                                            : (field.value || []).filter(
                                                                (value) => value !== issue.value
                                                            );
                                                        field.onChange(updatedIssues);
                                                    };
                                                    
                                                    return (
                                                        <>
                                                            <Checkbox
                                                                id={`issue-${issue.value}`}
                                                                checked={field.value?.includes(issue.value)}
                                                                onCheckedChange={() => toggleIssue()}
                                                            />
                                                            <FormLabel 
                                                                htmlFor={`issue-${issue.value}`}
                                                                className="font-normal cursor-pointer w-full"
                                                                onClick={(e) => {
                                                                    e.preventDefault();
                                                                    toggleIssue();
                                                                }}
                                                            >
                                                                {issue.label}
                                                            </FormLabel>
                                                        </>
                                                    );
                                                })()}
                                            </div>
                                        ))}
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </div>

                    <div className="border rounded-lg p-6 bg-slate-50">
                        <h2 className="text-lg font-semibold mb-4 text-slate-800">NIMH Data Archive</h2>

                        <FormField
                            control={form.control}
                            name="uploadToNda"
                            render={({ field }) => (
                                <FormItem className="pb-4">
                                    <div className="flex flex-row items-start space-x-3 space-y-0">
                                        <FormControl>
                                            <Checkbox
                                                checked={field.value}
                                                onCheckedChange={field.onChange}
                                                className="mt-1"
                                            />
                                        </FormControl>
                                        <div className="space-y-1 leading-none">
                                            <FormLabel className="text-base font-medium">
                                                Upload to NIMH Data Archive
                                            </FormLabel>
                                            <FormDescription>
                                                Check this if features from this interview should be uploaded to NDA.
                                            </FormDescription>
                                        </div>
                                    </div>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />
                    </div>

                    <div className="border rounded-lg p-6 bg-slate-50">
                        <h2 className="text-lg font-semibold mb-4 text-slate-800">Additional Information</h2>
                        <div className="space-y-6">
                            <FormField
                                control={form.control}
                                name="comments"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Comments</FormLabel>
                                        <FormControl>
                                            <Input placeholder="Any additional comments" {...field} className="bg-white" />
                                        </FormControl>
                                        <FormDescription>
                                            Any additional comments or notes about the interview.
                                        </FormDescription>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <FormField
                                    control={form.control}
                                    name="qcDatetime"
                                    render={({ field }) => {
                                        const formattedDate = field.value
                                            ? new Date(field.value).toISOString().slice(0, 16)
                                            : "";

                                        return (
                                            <FormItem>
                                                <FormLabel>QC Datetime</FormLabel>
                                                <FormControl>
                                                    <Input
                                                        disabled
                                                        type="datetime-local"
                                                        placeholder="YYYY-MM-DDTHH:MM"
                                                        value={formattedDate}
                                                        onChange={(e) => field.onChange(e.target.value)}
                                                        className="bg-white"
                                                    />
                                                </FormControl>
                                                <FormDescription>
                                                    Date and time of the quality check.
                                                </FormDescription>
                                                <FormMessage />
                                            </FormItem>
                                        );
                                    }}
                                />

                                <FormField
                                    control={form.control}
                                    name="qcUser"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>QC User</FormLabel>
                                            <FormControl>
                                                <Input placeholder="QC User" {...field} className="bg-white" />
                                            </FormControl>
                                            <FormDescription>
                                                The user who performed the quality check.
                                            </FormDescription>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />
                            </div>
                        </div>
                    </div>

                    <div className="flex gap-4 items-center justify-end pt-4">
                        <Button type="button" variant="outline" onClick={() => form.reset()}>
                            Reset
                        </Button>
                        <Button type="submit" className="px-8">Submit</Button>
                    </div>
                </form>
            </Form>
        </div>
    )
}