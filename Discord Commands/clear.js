// Discord Commands/clear.js
// Bulk delete recent messages while preserving the bot's reply

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("clear")
        .setDescription("Delete recent messages in this channel")
        .addIntegerOption(option =>
            option.setName("amount")
                .setDescription("How many messages to delete (1–99)")
                .setRequired(true)
                .setMinValue(1)
                .setMaxValue(99)
        ),

    async execute(interaction, client, utils) {
        try {
            const amount = interaction.options.getInteger("amount");

            if (!interaction.channel.deletable) {
                return await interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Cannot Delete")
                            .setDescription("I don't have permission to delete messages in this channel.")
                    ]
                });
            }

            // Get the bot's reply message so we don't delete it
            const replyMessage = await interaction.fetchReply();

            // Fetch a few extra messages in case the reply is included
            const messages = await interaction.channel.messages.fetch({
                limit: Math.min(amount + 5, 100)
            });

            // Exclude the bot's reply
            const messagesToDelete = messages
                .filter(msg => msg.id !== replyMessage.id)
                .first(amount);

            const deleted = await interaction.channel.bulkDelete(messagesToDelete, true);

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0x00FF00)
                        .setTitle("🗑️ Messages Cleared")
                        .addFields(
                            {
                                name: "Deleted",
                                value: `${deleted.size} message${deleted.size === 1 ? "" : "s"}`,
                                inline: true
                            },
                            {
                                name: "Channel",
                                value: interaction.channel.name,
                                inline: true
                            }
                        )
                ]
            });

        } catch (error) {
            console.error("Clear command error:", error);

            try {
                await interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Error")
                            .setDescription(error.message)
                    ]
                });
            } catch {
                // Reply may no longer exist
            }
        }
    }
};
