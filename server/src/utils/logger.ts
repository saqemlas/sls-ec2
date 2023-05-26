import winston, { Logger, format } from 'winston';
import 'winston-daily-rotate-file';

interface Log {
    debug: (msg: string, data?: Record<string, unknown> | undefined) => Logger;
    info: (msg: string, data?: Record<string, unknown> | undefined) => Logger;
    warn: (msg: string, data?: Record<string, unknown> | undefined) => Logger;
    error: (msg: string, data?: Record<string, unknown> | undefined) => Logger;
    winston: Logger;
}

const fileRotateTransport = process.env['IS_LOCAL'] 
    ?
        new winston.transports.Console({})
    : 
        new winston.transports.DailyRotateFile({
            filename: '/var/log/nodejs/application-%DATE%.log',
            datePattern: 'DD-MM-YYYY',
            maxFiles: '14d',
        });

const loggerBase: Logger = winston.createLogger({
    level: process.env['LOG_LEVEL'] || 'info',
    format: process.env['IS_LOCAL'] 
        ? format.combine(format.colorize(), format.align(), format.simple()) 
        : format.json(),
    transports: [fileRotateTransport],
});

const loggerWrapper = (logger: Logger): Log => ({
    debug: (msg: string, data?: Record<string, unknown>): Logger => logger.debug(msg, { data }),
    info: (msg: string, data?: Record<string, unknown>): Logger => logger.info(msg, { data }),
    warn: (msg: string, data?: Record<string, unknown>): Logger => logger.warn(msg, { data }),
    error: (msg: string, data?: Record<string, unknown>): Logger => logger.error(msg, { data }),
    winston: logger,
});

const logger: Log = loggerWrapper(loggerBase.child({}));

export { logger };
