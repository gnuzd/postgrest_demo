import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ locals }) => {
	const respChannels = await locals.api?.getChannels();
	return { channels: respChannels?.data };
};
