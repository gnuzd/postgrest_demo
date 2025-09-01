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
			toast.error(res?.message);
		}
	});
</script>

<div class="card w-sm border border-base-300 m-auto">
	<div class="card-body space-y-2">
		<div class="flex flex-col gap-1">
			<p class="text-xl font-semibold">Login</p>
			<p class="text-base-content/80">Enter your email below to login to your account</p>
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
			<Button type="submit" loading={$submitting} class="mt-5">Login</Button>
			<p class="text-center mt-3 text-base-content/80">
				Don't have an account? <a href="/register" class="link font-medium">Sign up</a>
			</p>
		</form>
	</div>
</div>
