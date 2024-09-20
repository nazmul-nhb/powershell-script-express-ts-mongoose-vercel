export interface IErrorObject extends Error {
	status?: number;
}

export interface IProductDetails {
	title: string;
	price: number;
	productImage: string;
}

export interface IUserPayload {
	email: string;
}

export interface IDecodedToken {
	email: string;
}

