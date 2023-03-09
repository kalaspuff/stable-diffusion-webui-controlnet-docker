        with gr.Box(visible=os.environ.get("SPACE_ID")):
            if os.environ.get("SPACE_ID") and str(os.environ.get("IS_SHARED_UI", "") or "") not in ("", "0"):
                gr.HTML(f"""
                <div class="gr-prose" style="max-width: 80%">
                    <p>Automatic1111 Stable Diffusion Web UI on 🤗 Hugging Face | Checkpoint: <a href="https://civitai.com/models/10752/the-allys-mix-iii-revolutions" style="target=" _blank"="">theAllysMixIII_v10</a></p>
                    <p>Docker setup: <a href="https://huggingface.co/spaces/carloscar/stable-diffusion-webui-docker" style="target=" _blank"="">🤗 Hugging Face ➔ carloscar/stable-diffusion-webui-docker</a> | <a href="https://github.com/kalaspuff/stable-diffusion-webui-docker" style="target=" _blank"="">🐙 GitHub ➔ kalaspuff/stable-diffusion-webui-docker</a></p>
                    <p>Duplicate this Space to run it privately without a queue + load additional checkpoints, VAE, LoRA models, etc.&nbsp;&nbsp;<a class="duplicate-button" style="display:inline-block" target="_blank" href="https://huggingface.co/spaces/{os.environ["SPACE_ID"]}?duplicate=true"><img style="margin: 0" src="https://img.shields.io/badge/-Duplicate%20Space-blue?labelColor=white&style=flat&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAP5JREFUOE+lk7FqAkEURY+ltunEgFXS2sZGIbXfEPdLlnxJyDdYB62sbbUKpLbVNhyYFzbrrA74YJlh9r079973psed0cvUD4A+4HoCjsA85X0Dfn/RBLBgBDxnQPfAEJgBY+A9gALA4tcbamSzS4xq4FOQAJgCDwV2CPKV8tZAJcAjMMkUe1vX+U+SMhfAJEHasQIWmXNN3abzDwHUrgcRGmYcgKe0bxrblHEB4E/pndMazNpSZGcsZdBlYJcEL9Afo75molJyM2FxmPgmgPqlWNLGfwZGG6UiyEvLzHYDmoPkDDiNm9JR9uboiONcBXrpY1qmgs21x1QwyZcpvxt9NS09PlsPAAAAAElFTkSuQmCC&logoWidth=14" alt="Duplicate Space"></a></p>
                </div>
                """)
            elif os.environ.get("SPACE_ID"):
                import torch
                if not torch.cuda.is_available():
                    gr.HTML(f"""
                    <div class="gr-prose" style="max-width: 80%">
                        <p>Docker setup: <a href="https://huggingface.co/spaces/carloscar/stable-diffusion-webui-docker" style="target=" _blank"="">🤗 Hugging Face ➔ carloscar/stable-diffusion-webui-docker</a> | <a href="https://github.com/kalaspuff/stable-diffusion-webui-docker" style="target=" _blank"="">🐙 GitHub ➔ kalaspuff/stable-diffusion-webui-docker</a></p>
                        <p>Load additional checkpoints, VAE, LoRA models, etc. Read more on the README at the GitHub link above.</p>
                        <p>This Space is currently running on CPU, which may yield very slow results - you can upgrade for a GPU <a href="https://huggingface.co/spaces/{os.environ["SPACE_ID"]}/settings" style="text-decoration: underline" target="_blank">in the Settings tab</a></p>
                    </div>
                    """)
                else:
                    gr.HTML(f"""
                    <div class="gr-prose" style="max-width: 80%">
                        <p>Docker setup: <a href="https://huggingface.co/spaces/carloscar/stable-diffusion-webui-docker" style="target=" _blank"="">🤗 Hugging Face ➔ carloscar/stable-diffusion-webui-docker</a> | <a href="https://github.com/kalaspuff/stable-diffusion-webui-docker" style="target=" _blank"="">🐙 GitHub ➔ kalaspuff/stable-diffusion-webui-docker</a></p>
                        <p>Load additional checkpoints, VAE, LoRA models, etc. Read more on the README at the GitHub link above.</p>
                        <p>This Space has GPU enabled - remember to remove the GPU from the space <a href="https://huggingface.co/spaces/{os.environ["SPACE_ID"]}/settings" style="text-decoration: underline" target="_blank">in the Settings tab</a> when you're done.</p>
                    </div>
                    """)
