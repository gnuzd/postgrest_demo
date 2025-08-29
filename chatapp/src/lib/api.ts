import { PUBLIC_API_ENDPOINT } from '$env/static/public';
import type { Axios, AxiosHeaders } from 'axios';
import axios from 'axios';

export default class Api {
	instance: Axios;

	constructor(token?: string) {
		this.instance = axios.create({
			baseURL: PUBLIC_API_ENDPOINT,
			headers: {
				Authorization: token ? `Bearer ${token}` : ''
			}
		});
	}

	login(email: string, password: string) {
		return this.instance.post('/rpc/login', { p_email: email, password });
	}

	register(email: string, password: string) {
		return this.instance.post('/rpc/register', { email, password });
	}

	async getMe() {
		try {
			const { data } = await this.getUsers();
			return data[0];
		} catch (error) {
			console.error(error);
			return null;
		}
	}

	getUsers() {
		return this.instance.get('/users', { headers: { 'Accept-Profile': 'private' } });
	}

	getChannels() {
		return this.instance.get('/users', { headers: { 'Accept-Profile': 'private' } });
	}

	createChannel({ name, description, isPrivate }: { name: string; description?: string; isPrivate?: boolean; }) {
		return this.instance.post('/channels', { name, description, is_private: isPrivate });
	}
}
