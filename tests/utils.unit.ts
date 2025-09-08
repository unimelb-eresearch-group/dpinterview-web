import {describe, vi, expect, test, beforeAll} from 'vitest'
import {makeFilePath} from "@/lib/utils";
import {NextRequest} from "next/server";
import {env} from "@/env";

describe("makeFileUrl", () => {

    beforeAll(() => {
        vi.mock("../src/env.js", () => {
            return {
                env: {
                    NEXT_PUBLIC_FILE_PREFIX: "/files/",
                    NEXT_PUBLIC_PATH_PREFIX: "/test/prefix/",
                    DATABASE_URL: "",
                }
            }
        })
    });

    test("test mock", () => {
        expect(env.NEXT_PUBLIC_PATH_PREFIX).to.eq("/test/prefix/");
        expect(env.NEXT_PUBLIC_FILE_PREFIX).eq("/files/");
    })

    test("path prefix should be removed", () => {
        const testPath = "/test/prefix/data"
        const result = makeFilePath(testPath);
        expect(result).to.eq("/files/data")
    });

    test("path prefix not removed if not present", () => {
        const testPath = "/prefix/data"
        const result = makeFilePath(testPath);
        expect(result).to.eq("/files/prefix/data")
    });

    test("path prefix not removed if not present", () => {
        const testPath = "/prefix/test/prefix/value"
        const result = makeFilePath(testPath);
        expect(result).to.eq("/files/prefix/test/prefix/value")
    });


});