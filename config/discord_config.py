from pydantic import BaseSettings, Field


class DiscordConfig(BaseSettings):
    """
    Discord client settings
    """

    TOKEN: str = Field(
        env="DISCORD_TOKEN",
        default=None
    )
