// Discord Commands/userinfo.js
// Example: show info about a user in this server

const { SlashCommandBuilder, EmbedBuilder } = require("discord.js");

module.exports = {
    data: new SlashCommandBuilder()
        .setName("userinfo")
        .setDescription("Show info about a user in this server")
        .addUserOption(option =>
            option.setName("user")
                .setDescription("The user to look up")
                .setRequired(false)
        ),

    async execute(interaction, client, utils) {
        try {
            const target = interaction.options.getUser("user") || interaction.user;
            const member = await interaction.guild.members.fetch(target.id).catch(() => null);

            const embed = new EmbedBuilder()
                .setColor(0x5865F2)
                .setTitle(`User Info — ${target.tag}`)
                .setThumbnail(target.displayAvatarURL({ dynamic: true, size: 256 }))
                .addFields(
                    { name: "ID", value: target.id, inline: true },
                    { name: "Username", value: target.username, inline: true },
                    { name: "Global Name", value: target.displayName || target.globalName || "—", inline: true },
                    { name: "Created", value: `<t:${Math.floor(target.createdTimestamp / 1000)}:R>`, inline: true },
                    { name: "Bot", value: target.bot ? "Yes" : "No", inline: true }
                );

            if (member) {
                const roleList = member.roles.cache
                    .filter(r => r.id !== interaction.guild.id)
                    .sort((a, b) => b.position - a.position)
                    .slice(0, 15)
                    .map(r => r.toString())
                    .join(", ") || "None";

                embed
                    .addFields(
                        { name: "Joined Server", value: `<t:${Math.floor(member.joinedTimestamp / 1000)}:R>`, inline: true },
                        { name: "Roles", value: roleList.slice(0, 512) }
                    )
                    .setFooter({ text: `Member #${member.id}` });
            }

            await interaction.editReply({ embeds: [embed] });
        } catch (error) {
            console.error("Userinfo command error:", error);
            await interaction.editReply({
                embeds: [
                    new EmbedBuilder()
                        .setColor(0xFF0000)
                        .setTitle("❌ Error")
                        .setDescription("Something went wrong while fetching user info.")
                ]
            });
        }
    }
};
