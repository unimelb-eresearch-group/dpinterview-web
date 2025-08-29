import {env} from "@/env";
import {Pool} from 'pg';

const connection: Pool = new Pool({
    connectionString: env.DATABASE_URL,
});

export function getConnection(): Pool {
    return connection;
}

export default connection;
