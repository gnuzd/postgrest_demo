import { PUBLIC_API_ENDPOINT } from '$env/static/public';
import type { Axios } from 'axios';
import axios from 'axios';

export default class Api {
	instance: Axios;

	constructor() {
		this.instance = axios.create({
			baseURL: PUBLIC_API_ENDPOINT
		});
	}

	login(email: string, password: string) {
		return this.instance.post('/rpc/login', { p_email: email, password });
	}
}
