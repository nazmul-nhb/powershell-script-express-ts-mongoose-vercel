import { Document } from "mongoose";

export interface IProduct extends Document {
	title: string;
	price: number;
	productImage: string;
	createdAt: Date;
}
