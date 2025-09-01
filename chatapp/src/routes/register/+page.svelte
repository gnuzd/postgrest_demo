<script>
	import { toast } from 'svelte-sonner';
	import { superForm } from 'sveltekit-superforms';
	import { zodClient } from 'sveltekit-superforms/adapters';

	import Button from '$lib/components/Button.svelte';
	import Input from '$lib/components/Input.svelte';
	import { loginSchema } from '$lib/schema';

	const { form, enhance, errors, submitting, message } = superForm(
		{ email: '', password: '' },
		{ validators: zodClient(loginSchema) }
	);

	message.subscribe((res) => {
		if (res?.error) {
			toast.error(res.message);
		}
	});
</script>

<div class="card w-sm border border-base-300 m-auto">
	<div class="card-body space-y-2">
		<div class="flex flex-col gap-1">
			<p class="text-xl font-semibold">Register</p>
			<p class="text-base-content/80">Enter your email below to register new account</p>
		</div>
		<form class="flex flex-col" method="POST" use:enhance>
			<Input
				label="Email"
				type="email"
				name="email"
				error={!!$errors.email?.length}
				bind:value={$form.email}
				hint={$errors.email?.[0]}
			/>
			<Input
				label="Password"
				type="password"
				name="password"
				bind:value={$form.password}
				error={!!$errors.password?.length}
				hint={$errors.password?.[0]}
			/>
			<Button type="submit" loading={$submitting} class="mt-5">Register</Button>
			<p class="text-center mt-3 text-base-content/80">
				Already have an account? <a href="/login" class="link font-medium">Sign in</a>
			</p>
		</form>
	</div>
</div>
