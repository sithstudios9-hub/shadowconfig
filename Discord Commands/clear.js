// Discord Commands/clear.js
// Example: bulk delete recent messages in this channel

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
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Cannot Delete")
                            .setDescription("I don't have permission to delete messages in this channel.")
                    ]
                });
            }

            const deleted = await interaction.channel.bulkDelete(amount, true);

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0x00FF00)
                        .setTitle("🗑️ Messages Cleared")
                        .addFields(
                            { name: "Deleted", value: `${deleted.size} message${deleted.size === 1 ? "" : "s"}`, inline: true },
                            { name: "Channel", value: interaction.channel.name, inline: true }
                        )
                ]
            });
        } catch (error) {
            console.error("Clear command error:", error);
            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0xFF0000)
                        .setTitle("❌ Error")
                        .setDescription(error.message)
                ]
            });
        }
    }
};
