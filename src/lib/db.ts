import {URL} from "node:url";
import {env} from "@/env";
import {Pool, PoolConfig} from 'pg';

const connection: Pool = new Pool(makeConfig());

function makeConfig(): PoolConfig {
    const dbUrl = new URL(env.DATABASE_URL);
    return {
        user: dbUrl.username,
        host: dbUrl.host,
        database: dbUrl.pathname,
        password: dbUrl.password,
        port: parseInt(dbUrl.port),
        ssl: {
            rejectUnauthorized: false,
        }
    };
}

export function getConnection(): Pool {
    if (!connection) {
        throw new Error("Database connection is undefined");
    }
    return connection;
}

export default connection;
