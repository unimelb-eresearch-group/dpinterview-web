import {createEnv} from "@t3-oss/env-nextjs";
import {z} from "zod";

export const env = createEnv({
    server: {
        DATABASE_URL: z.string().url(),
    },
    client: {
        NEXT_PUBLIC_FILE_PREFIX: z.string().min(1).default("/payload/"), // URL prefix that files are accessible at
        NEXT_PUBLIC_PATH_PREFIX: z.string().min(1).default("/var/lib/prescient/data/"), // prefix to strip from paths
    },
    experimental__runtimeEnv: {
        NEXT_PUBLIC_FILE_PREFIX: process.env.NEXT_PUBLIC_FILE_PREFIX,
        NEXT_PUBLIC_PATH_PREFIX: process.env.NEXT_PUBLIC_PATH_PREFIX,
    }, // No client env vars
});