import type { AxiosInstance } from 'axios';

export class Auth {
	instance: AxiosInstance;

	constructor(instance: AxiosInstance) {
		this.instance = instance;
	}

	login(email: string, password: string) {
		return this.instance.post('/rpc/login', { p_email: email, password });
	}

	register(email: string, password: string) {
		return this.instance.post('/rpc/register', { email, password });
	}

	async getMe() {
		try {
			const { data } = await this.instance.get('/users', {
				headers: { 'Accept-Profile': 'private' }
			});

			return data[0];
		} catch (error) {
			console.log(error);
			return null;
		}
	}
}
