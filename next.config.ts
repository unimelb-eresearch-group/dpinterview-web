import type {NextConfig} from "next";

const nextConfig: NextConfig = {
    output: "standalone",
    transpilePackages: ["@t3-oss/env-nextjs", "@t3-oss/env-core"],
    compiler: {
        removeConsole: {
            exclude: ['warn', 'error'],
        },
    }
};

export default nextConfig;
