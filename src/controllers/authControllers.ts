import { NextFunction, Request, Response } from 'express';
import { IUserPayload } from '../types/interfaces';
import jwt from 'jsonwebtoken';

export const sendToken = (
	req: Request<{}, {}, IUserPayload>,
	res: Response,
	next: NextFunction,
) => {
	try {
		const user = req.body;
		const tokenSecret = process.env.TOKEN_SECRET;
		if (!tokenSecret) {
			return res.status(500).send({ message: 'Token Secret Not Configured!' });
		}
		const token = jwt.sign(user, tokenSecret);
		res.send({ token });
	} catch (error) {
		if (error instanceof Error) {
			console.error('Error Creating Token: ', error.message);
			res.status(400).send({
				success: false,
				message: error.message,
			});
		} else {
			next(error);
		}
	}
};

