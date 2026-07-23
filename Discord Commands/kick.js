// Discord Commands/kick.js
// Example: kick a user from this server

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("kick")
        .setDescription("Kick a user from this server")
        .addUserOption(option =>
            option.setName("user")
                .setDescription("The user to kick")
                .setRequired(true)
        )
        .addStringOption(option =>
            option.setName("reason")
                .setDescription("Reason for kicking")
                .setRequired(false)
                .setMaxLength(512)
        ),

    async execute(interaction, client, utils) {
        try {
            const target = interaction.options.getUser("user");
            const reason = interaction.options.getString("reason") || "No reason provided";

            if (target.id === interaction.user.id) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Invalid Target")
                            .setDescription("You can't kick yourself.")
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

            if (!member.kickable) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ Cannot Kick")
                            .setDescription("I don't have permission to kick this user, or their role is higher than mine.")
                    ]
                });
            }

            await member.kick(reason);

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0x00FF00)
                        .setTitle("👢 User Kicked")
                        .addFields(
                            { name: "User", value: `${target.tag} (${target.id})`, inline: true },
                            { name: "Reason", value: reason }
                        )
                ]
            });
        } catch (error) {
            console.error("Kick command error:", error);
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
