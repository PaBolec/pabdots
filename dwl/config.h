/* dwl config — voidrice-inspired, adapted for paul's setup
 * Modkey = Super. Terminal = kitty. Launcher = fuzzel.
 * Based on dwl's stock config.def.h structure. */

#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                         ((hex >> 16) & 0xFF) / 255.0f, \
                         ((hex >> 8) & 0xFF) / 255.0f, \
                         (hex & 0xFF) / 255.0f }

static const int sloppyfocus               = 1;
static const int bypass_surface_visibility  = 0;
static const unsigned int borderpx          = 1;
static const float rootcolor[]              = COLOR(0x0d0d0dff);
static const float bordercolor[]            = COLOR(0x333333ff);
static const float focuscolor[]             = COLOR(0x888888ff);
static const float urgentcolor[]            = COLOR(0xc94f4fff);
static const float fullscreen_bg[]          = {0.1, 0.1, 0.1, 1.0};

static const unsigned int gappih = 0;
static const unsigned int gappiv = 0;
static const unsigned int gappoh = 0;
static const unsigned int gappov = 0;
static const int smartgaps = 0;

static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* app_id      title       tags mask  isfloating  monitor */
	{ "kitty",     NULL,       0,          0,          -1 },
};

static const Layout layouts[] = {
	{ "[]=",      tile },
	{ "><>",      NULL },  /* floating */
	{ "[M]",      monocle },
};

#define MODKEY WLR_MODIFIER_LOGO
#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static const char *termcmd[]  = { "kitty", NULL };
static const char *menucmd[]  = { "fuzzel", NULL };
static const char *filemgr[]  = { "kitty", "-e", "ranger", NULL };

static const Key keys[] = {
	/* modifier                  key               function        argument */
	{ MODKEY,                    XKB_KEY_Return,   spawn,          {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_r,        spawn,          {.v = menucmd} },
	{ MODKEY,                    XKB_KEY_e,        spawn,          {.v = filemgr} },
	{ MODKEY,                    XKB_KEY_q,        killclient,     {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_q,        quit,           {0} },

	{ MODKEY,                    XKB_KEY_j,        focusstack,     {.i = +1} },
	{ MODKEY,                    XKB_KEY_k,        focusstack,     {.i = -1} },
	{ MODKEY,                    XKB_KEY_i,        incnmaster,     {.i = +1} },
	{ MODKEY,                    XKB_KEY_d,        incnmaster,     {.i = -1} },
	{ MODKEY,                    XKB_KEY_h,        setmfact,       {.f = -0.05} },
	{ MODKEY,                    XKB_KEY_l,        setmfact,       {.f = +0.05} },

	{ MODKEY,                    XKB_KEY_t,        setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                    XKB_KEY_f,        setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                    XKB_KEY_m,        setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                    XKB_KEY_space,    togglefloating, {0} },

	{ MODKEY,                    XKB_KEY_1,        view,           {.ui = 1 << 0} },
	TAGKEYS(XKB_KEY_1, XKB_KEY_exclam, 0),
	TAGKEYS(XKB_KEY_2, XKB_KEY_at, 1),
	TAGKEYS(XKB_KEY_3, XKB_KEY_numbersign, 2),
	TAGKEYS(XKB_KEY_4, XKB_KEY_dollar, 3),
	TAGKEYS(XKB_KEY_5, XKB_KEY_percent, 4),
	TAGKEYS(XKB_KEY_6, XKB_KEY_asciicircum, 5),
	TAGKEYS(XKB_KEY_7, XKB_KEY_ampersand, 6),
	TAGKEYS(XKB_KEY_8, XKB_KEY_asterisk, 7),
	TAGKEYS(XKB_KEY_9, XKB_KEY_parenleft, 8),

	{ MODKEY,                    XKB_KEY_Tab,      view,           {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_space,    zoom,           {0} },

	/* media / brightness — same keys voidrice uses */
	{ 0, XKB_KEY_XF86AudioRaiseVolume, spawn, SHCMD("pamixer -i 5") },
	{ 0, XKB_KEY_XF86AudioLowerVolume, spawn, SHCMD("pamixer -d 5") },
	{ 0, XKB_KEY_XF86AudioMute,        spawn, SHCMD("pamixer -t") },
	{ 0, XKB_KEY_XF86MonBrightnessUp,   spawn, SHCMD("brightnessctl set +5%") },
	{ 0, XKB_KEY_XF86MonBrightnessDown, spawn, SHCMD("brightnessctl set 5%-") },

	/* bluetooth control panel */
	{ MODKEY, XKB_KEY_b, spawn, SHCMD("kitty -e bluetuith") },
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
