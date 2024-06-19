# FriendCheck

- "fc (on|off)" to enable/disable
- "fc update check" to check for updates
- "fc update install" to install updates
- "fc config" shows current configuration
- "fc config tag &lt;colorcode&gt;" lets you set your "(Friend)" color
  - EXAMPLE: fc config tag @G
- "fc config text &lt;colorcode&gt;" lets you set the color to match the friend channel text
  - EXAMPLE: fc config text @C
  - Both "tag" and "text" should support those newfangled fancy colorcodes @x1234 or whatever they are.
- "fc config tracker &lt;tracker alias&gt;" lets you set the alias you use for tracker channel (usually "tracker")
  - EXAMPLE: fc config tracker tracker
- "fc config reset" resets all config to defaults (@G for tag, @C for text, no alias for tracker)


# SeekRep

A plugin to collect and report "Seek" clanskill output

`seekrep &lt;target&gt; [top|bot] [quantity]`
- &lt;target&gt;    Required. Single keyword of target. Ordinal targets are ok (1.lasher, 2.lasher, etc.). Multiple words or quotes are not.
- [top|bot]   Optional. Sort order. defaults to "bot". "bot" sorts ascending, "top" sorts descending. 
- [quantity]  Optional. Restricts quantity of results.

> [!NOTE]
> While "seekrep &lt;target&gt;" works, it is ugly. that's a work in progress. I suggest not using that syntax. Always (for now) provide the top/bot and quantity bits.
