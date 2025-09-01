import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { message } from 'sveltekit-superforms';
import { fail } from '@sveltejs/kit';

import { channleSchema, messageSchema } from '$lib/schema';
import type { Actions } from './$types';
import Api from '$lib/api';

export const actions = {
	createChannel: async ({ request, locals, cookies }) => {
		const token = cookies.get('session_token');
		const form = await superValidate(request, zod(channleSchema));

		if (!token) return fail(403, { form });
		if (!form.valid) return fail(400, { form });

		try {
			const api = new Api(token);
			const res = await api.channel.create({ ...form.data });
			return message(form, { data: res?.data?.[0] });
		} catch (error: any) {
			return message(form, { error: true, message: error.message }, { status: 400 });
		}
	},
	createMessage: async ({ cookies, request, url }) => {
		const token = cookies.get('session_token');
		const form = await superValidate(request, zod(messageSchema));

		if (!token) return fail(403, { form });
		if (!form.valid) return fail(400, { form });
		console.log(form.data);

		try {
			const api = new Api(token);
			const res = await api.message.create({
				content: form.data.content,
				channelId: form.data.channelId
			});
			return message(form, { data: res?.data?.[0] });
		} catch (error: any) {
			return message(form, { error: true, message: error.message }, { status: 400 });
		}
	}
} satisfies Actions;
