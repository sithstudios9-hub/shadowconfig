// Discord Commands/ban.js
// Example: ban a user from this server

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("ban")
        .setDescription("Ban a user from this server")
        .addUserOption(option =>
            option.setName("user")
                .setDescription("The user to ban")
                .setRequired(true)
        )
        .addStringOption(option =>
            option.setName("reason")
                .setDescription("Reason for banning")
                .setRequired(false)
                .setMaxLength(512)
        )
        .addIntegerOption(option =>
            option.setName("delete_days")
                .setDescription("Days of messages to delete (0–7)")
                .setRequired(false)
                .setMinValue(0)
                .setMaxValue(7)
        ),

    async execute(interaction, client, utils) {
        try {
            const target = interaction.options.getUser("user");
            const reason = interaction.options.getString("reason") || "No reason provided";
            const deleteDays = interaction.options.getInteger("delete_days") || 0;

            if (target.id === interaction.user.id) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Invalid Target")
                            .setDescription("You can't ban yourself.")
                    ]
                });
            }

            const member = await interaction.guild.members.fetch(target.id).catch(() => null);
            if (member) {
                if (!member.bannable) {
                    return interaction.editReply({
                        embeds: [
                            new EmbedBuilder()
                                .setColor(0xFF0000)
                                .setTitle("❌ Cannot Ban")
                                .setDescription("I don't have permission to ban this user, or their role is higher than mine.")
                        ]
                    });
                }

                await member.ban({ deleteMessageSeconds: deleteDays * 24 * 60 * 60, reason });
            } else {
                await interaction.guild.bans.create(target.id, {
                    deleteMessageSeconds: deleteDays * 24 * 60 * 60,
                    reason
                });
            }

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0xFF0000)
                        .setTitle("🔨 User Banned")
                        .addFields(
                            { name: "User", value: `${target.tag} (${target.id})`, inline: true },
                            { name: "Deleted Messages", value: `${deleteDays} day${deleteDays === 1 ? "" : "s"}`, inline: true },
                            { name: "Reason", value: reason }
                        )
                ]
            });
        } catch (error) {
            console.error("Ban command error:", error);
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
