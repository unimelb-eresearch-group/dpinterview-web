#!/usr/bin/env node

import process from 'node:process';


async function healthcheck() {

    const port = process.env.PORT || "3000";
    const url = `http://localhost:${port}`

    try {
        return await fetch(url, {
            method: "HEAD", signal: AbortSignal.timeout(500) // Built-in timeout support
        });
    } catch (error) {
        if (error.name === 'TimeoutError') {
            throw new Error('Request timed out');
        }
        throw error;
    }
}

async function main() {
    try {
        const response = await healthcheck();
        if (!response) {
            process.exitCode = 1;
        } else if (response.ok) {
            process.exitCode = 0;
        } else {
            process.exitCode = 1;
        }
    } catch {
        process.exitCode = 2;
    }
}

await main();