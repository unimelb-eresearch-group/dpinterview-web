import {clsx, type ClassValue} from "clsx"
import {twMerge} from "tailwind-merge"
import {env} from "@/env";

export function cn(...inputs: ClassValue[]) {
    return twMerge(clsx(inputs))
}

export function makeFilePath(path: string): string {
    // Remove prefix if set
    const trimmedPath = path.replace(new RegExp(`^${env.NEXT_PUBLIC_PATH_PREFIX}/{0,1}`,"m"), "");
    // Form new path and replace any runs of `/` from a single `/`
    return [env.NEXT_PUBLIC_FILE_PREFIX, trimmedPath].join("/").replace(/\/{2,}/, "/");
}