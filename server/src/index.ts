import 'dotenv/config';
import { logger } from './utils/logger';
import express, { Request, Response } from 'express';
import cors from 'cors';

const app = express();
const port: number = Number(process.env['PORT']);

app.use(cors());

app.get('/', async (req: Request, res: Response) => {
    logger.info('event :', { req });

  res
    .status(200)
    .json({
      id: req.headers.referer,
      message: 'Welcome from AWS EC2!'
    })

});

app.listen(port, () => logger.info(`Listening on port ${port}...`));
