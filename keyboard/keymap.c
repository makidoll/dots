#include QMK_KEYBOARD_H

#define LAST_LAYER 2

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    // standard layout
    [0] = LAYOUT_60_ansi(
        KC_ESC, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0, KC_MINS, KC_EQL,  KC_BSPC,
        KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_I, KC_O, KC_P, KC_LBRC, KC_RBRC, KC_BSLS,
        MO(LAST_LAYER), KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_J, KC_K, KC_L, KC_SCLN, KC_QUOT, KC_ENT,
        KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_RSFT,
        KC_LCTL, KC_LGUI, KC_LALT, KC_SPC, KC_RALT, MO(LAST_LAYER), KC_APP, KC_RCTL
    ),
    // standard layout, ijkl are arrow keys
    [1] = LAYOUT_60_ansi(
        KC_ESC, KC_1, KC_2, KC_3, KC_4, KC_5, KC_6, KC_7, KC_8, KC_9, KC_0, KC_MINS, KC_EQL, KC_BSPC,
        KC_TAB, KC_Q, KC_W, KC_E, KC_R, KC_T, KC_Y, KC_U, KC_UP, KC_O, KC_P, KC_LBRC, KC_RBRC, KC_BSLS,
        MO(LAST_LAYER), KC_A, KC_S, KC_D, KC_F, KC_G, KC_H, KC_LEFT, KC_DOWN, KC_RGHT, KC_SCLN, KC_QUOT, KC_ENT,
        KC_LSFT, KC_Z, KC_X, KC_C, KC_V, KC_B, KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, KC_RSFT,
        KC_LCTL, KC_LGUI, KC_LALT, KC_SPC, KC_RALT, MO(LAST_LAYER), KC_APP, KC_RCTL
    ),
    // all the others keys are here
    [LAST_LAYER] = LAYOUT_60_ansi(
        KC_GRV, KC_F1, KC_F2, KC_F3, KC_F4, KC_F5, KC_F6, KC_F7, KC_F8, KC_F9, KC_F10, KC_F11, KC_F12, KC_DEL,
        KC_TAB, KC_MPRV, KC_MPLY, KC_MNXT, KC_R, KC_T, KC_Y, KC_PGUP, KC_UP, KC_PGDN, KC_PSCR, KC_SCRL, KC_PAUS, KC_BSLS,
        KC_TRNS, KC_F14, KC_VOLD, KC_VOLU, KC_MUTE, KC_G, KC_HOME, KC_LEFT, KC_DOWN, KC_RGHT, KC_INS, KC_DEL, KC_ENT,
        KC_LSFT, KC_F15, KC_F16, KC_F17, KC_V, KC_B, KC_END, KC_M, KC_COMM, DF(1), DF(0), KC_RSFT,
        KC_LCTL, KC_LGUI, KC_LALT, KC_SPC, KC_RALT, KC_TRNS, KC_APP, KC_RCTL
    )
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case KC_BSLS:
            if (
                record->event.pressed &&
                layer_state_is(LAST_LAYER) &&
                get_mods() == MOD_BIT(KC_LEFT_CTRL)
            ) {
                reset_keyboard(); // jump to bootloader
                return false;
            } else {
                return true;
            }

        default:
            return true;
    }
}

#if defined(ENCODER_ENABLE) && defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {

};
#endif // defined(ENCODER_ENABLE) && defined(ENCODER_MAP_ENABLE)

