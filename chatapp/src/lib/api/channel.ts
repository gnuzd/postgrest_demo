import type { AxiosInstance } from 'axios';

export class Channel {
	instance: AxiosInstance;
	token?: string;

	constructor(instance: AxiosInstance) {
		this.instance = instance;
	}

	list() {
		return this.instance.get('/channels', { headers: { 'Accept-Profile': 'private' } });
	}

	create(args: { name: string; description?: string; isPrivate?: boolean }) {
		return this.instance.post(
			'/channels',
			{ name: args.name, description: args.description, is_private: args.isPrivate },
			{
				headers: {
					Prefer: 'return=representation',
					'Content-Profile': 'private'
				}
			}
		);
	}

	getAccess() {}
}
