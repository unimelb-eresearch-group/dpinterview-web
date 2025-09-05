import {clsx, type ClassValue} from "clsx"
import {twMerge} from "tailwind-merge"
import {env} from "@/env";

export function cn(...inputs: ClassValue[]) {
    return twMerge(clsx(inputs))
}

export function makeFileUrl(path: string): URL {
    // Remove prefix if set
    path.replace(env.NEXT_PUBLIC_PATH_PREFIX, "");

    const output = new URL(path, env.NEXT_PUBLIC_FILE_PREFIX);
    return output;
}