import { PUBLIC_API_ENDPOINT } from '$env/static/public';
import type { AxiosInstance } from 'axios';
import axios from 'axios';
import { Channel } from './channel';
import { Auth } from './auth';
import { Message } from './message';

export default class Api {
	private instance: AxiosInstance;

	auth: Auth;
	channel: Channel;
	message: Message;

	constructor(token?: string) {
		let headers = {};
		if (token) {
			headers = {
				Authorization: `Bearer ${token}`
			};
		}

		this.instance = axios.create({
			baseURL: PUBLIC_API_ENDPOINT,
			headers
		});

		this.auth = new Auth(this.instance);
		this.channel = new Channel(this.instance);
		this.message = new Message(this.instance);
	}
}
