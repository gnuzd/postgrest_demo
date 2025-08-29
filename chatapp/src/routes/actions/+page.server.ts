import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { message } from 'sveltekit-superforms';
import { fail } from '@sveltejs/kit';

import { channleSchema } from '$lib/schema';
import Api from '$lib/api';
import type { Actions } from './$types';

export const actions: Actions = {
	createChannel: async ({ request, locals }) => {
		const form = await superValidate(request, zod(channleSchema));

		if (!form.valid) {
			return fail(400, { form });
		}

		try {
			const respCreateChannel = await locals.api?.createChannel(form.data);
			return message(form, { data: respCreateChannel?.data });
		} catch (error: any) {
			return message(form, error.message, { status: 400 });
		}
	}
};
