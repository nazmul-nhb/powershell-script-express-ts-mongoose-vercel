import express, { Router } from 'express';
import { sendToken } from '../controllers/authControllers';

const router: Router = express.Router();

router.post('/', sendToken);

export default router;

