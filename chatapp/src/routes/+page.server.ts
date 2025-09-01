import Api from '$lib/api';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ cookies, url, locals }) => {
	const token = cookies.get('session_token');

	const api = new Api(token);
	const respChannels = await api.channel.list();

	let messages = [];
	const channel = url.searchParams.get('channel');
	if (channel) {
		const { data } = await api.message.list(channel);
		messages = data;
	}
	return { channels: respChannels?.data, messages, user: locals.user };
};
