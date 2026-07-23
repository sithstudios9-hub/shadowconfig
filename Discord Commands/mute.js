// Discord Commands/mute.js
// Example: timeout (mute) a user in this server

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

const MAX_MINUTES = 40320; // 28 days

function clampDuration(minutes) {
    if (!Number.isFinite(minutes)) return 5;
    return Math.max(1, Math.min(minutes, MAX_MINUTES));
}

module.exports = {
    data: new SlashCommandBuilder()
        .setName("mute")
        .setDescription("Timeout a user in this server")
        .addUserOption(option =>
            option.setName("user")
                .setDescription("The user to mute")
                .setRequired(true)
        )
        .addIntegerOption(option =>
            option.setName("minutes")
                .setDescription("Minutes to mute (1–40320)")
                .setRequired(true)
                .setMinValue(1)
                .setMaxValue(MAX_MINUTES)
        )
        .addStringOption(option =>
            option.setName("reason")
                .setDescription("Reason for muting")
                .setRequired(false)
                .setMaxLength(512)
        ),

    async execute(interaction, client, utils) {
        try {
            const target = interaction.options.getUser("user");
            const minutes = clampDuration(interaction.options.getInteger("minutes"));
            const reason = interaction.options.getString("reason") || "No reason provided";

            if (target.id === interaction.user.id) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Invalid Target")
                            .setDescription("You can't mute yourself.")
                    ]
                });
            }

            const member = await interaction.guild.members.fetch(target.id).catch(() => null);
            if (!member) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ User Not Found")
                            .setDescription("That user is not in this server.")
                    ]
                });
            }

            if (!member.moderatable) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Cannot Mute")
                            .setDescription("I don't have permission to mute this user, or their role is higher than mine.")
                    ]
                });
            }

            const durationMs = minutes * 60 * 1000;
            await member.timeout(durationMs, reason);

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0xFFFF00)
                        .setTitle("🔇 User Muted")
                        .addFields(
                            { name: "User", value: `${target.tag} (${target.id})`, inline: true },
                            { name: "Duration", value: `${minutes} minute${minutes === 1 ? "" : "s"}`, inline: true },
                            { name: "Reason", value: reason }
                        )
                ]
            });
        } catch (error) {
            console.error("Mute command error:", error);
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
