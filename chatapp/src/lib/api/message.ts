import type { AxiosInstance } from 'axios';

export class Message {
	instance: AxiosInstance;

	constructor(instance: AxiosInstance) {
		this.instance = instance;
	}

	list(channelId: string) {
		return this.instance.get('/messages?select=*,users(email)', {
			params: {
				channel_id: `eq.${channelId}`
			},
			headers: { 'Accept-Profile': 'private' }
		});
	}

	create(args: { channelId: string; content: string }) {
		return this.instance.post(
			'/messages',
			{ channel_id: args.channelId, content: args.content },
			{
				headers: {
					Prefer: 'return=representation',
					'Content-Profile': 'private'
				}
			}
		);
	}
}
