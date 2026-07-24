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

            // Exclude the bot's reply, then cap to the requested amount
            const messagesToDelete = messages
                .filter(msg => msg.id !== replyMessage.id)
                .first(amount);

            // Nothing to delete — don't call bulkDelete on an empty array
            if (messagesToDelete.length === 0) {
                return await interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFFA500)
                            .setTitle("⚠️ Nothing to Delete")
                            .setDescription("There were no other messages in this channel to delete.")
                    ]
                });
            }

            // Discord's bulkDelete requires 2+ messages; handle the single-message
            // case with a normal delete instead of letting bulkDelete throw.
            let deletedCount;
            let skippedOld = 0;

            if (messagesToDelete.length === 1) {
                const target = messagesToDelete[0];
                const isOld = Date.now() - target.createdTimestamp > 14 * 24 * 60 * 60 * 1000;
                if (isOld) {
                    skippedOld = 1;
                    deletedCount = 0;
                } else {
                    await target.delete();
                    deletedCount = 1;
                }
            } else {
                const requested = messagesToDelete.length;
                const deleted = await interaction.channel.bulkDelete(messagesToDelete, true);
                deletedCount = deleted.size;
                skippedOld = requested - deletedCount;
            }

            const fields = [
                {
                    name: "Deleted",
                    value: `${deletedCount} message${deletedCount === 1 ? "" : "s"}`,
                    inline: true
                },
                {
                    name: "Channel",
                    value: interaction.channel.name,
                    inline: true
                }
            ];

            if (skippedOld > 0) {
                fields.push({
                    name: "Skipped",
                    value: `${skippedOld} message${skippedOld === 1 ? "" : "s"} older than 14 days (Discord limitation)`,
                    inline: false
                });
            }

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(deletedCount > 0 ? 0x00FF00 : 0xFFA500)
                        .setTitle(deletedCount > 0 ? "🗑️ Messages Cleared" : "⚠️ Nothing Deleted")
                        .addFields(fields)
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
