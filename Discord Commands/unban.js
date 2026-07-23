// Discord Commands/unban.js
// Example: unban a user from this server

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("unban")
        .setDescription("Unban a user from this server")
        .addStringOption(option =>
            option.setName("user")
                .setDescription("User ID or username#0000")
                .setRequired(true)
        )
        .addStringOption(option =>
            option.setName("reason")
                .setDescription("Reason for unbanning")
                .setRequired(false)
                .setMaxLength(512)
        ),

    async execute(interaction, client, utils) {
        try {
            const input = interaction.options.getString("user").trim();
            const reason = interaction.options.getString("reason") || "No reason provided";

            let targetUser = null;

            if (/^\d+$/.test(input)) {
                try {
                    targetUser = await client.users.fetch(input);
                } catch {
                    targetUser = null;
                }
            }

            if (!targetUser) {
                const bans = await interaction.guild.bans.fetch();
                targetUser = bans.find(b => {
                    const username = b.user.username.toLowerCase();
                    const discriminator = b.user.discriminator;
                    return username === input || `${username}#${discriminator}` === input;
                })?.user || null;
            }

            if (!targetUser) {
                return interaction.editReply({
                    embeds: [
                        new EmbedBuilder()
                            .setColor(0xFF0000)
                            .setTitle("❌ User Not Found")
                            .setDescription("Could not find a banned user matching that ID or username.")
                    ]
                });
            }

            await interaction.guild.bans.remove(targetUser.id, reason);

            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0x00FF00)
                        .setTitle("🔓 User Unbanned")
                        .addFields(
                            { name: "User", value: `${targetUser.tag} (${targetUser.id})`, inline: true },
                            { name: "Reason", value: reason }
                        )
                ]
            });
        } catch (error) {
            console.error("Unban command error:", error);
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
