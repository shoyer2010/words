//
//  CacheKey.swift
//  words
//
//  Created by shoyer on 15/2/21.
//  Copyright (c) 2015年 shoyer. All rights reserved.
//

// NOTE: do not change the key value unless you know what your are doing.

struct CacheKey {
    static let APP_URL = "app_url"
    static let USER = "user"
    static let LEARNING_CUSTOM_DICTIONARY = "learning_custom_dictionary"
    static let LEARNING_DICTIONARY = "learning_dictionary"
    static let DICTIONARY_LIST = "dictionary_list"
    static let WORD_PHONETIC_TYPE = "word_phonetic_type"
    static let WORD_AUTO_VOICE = "word_auto_voice"
    static let SENTENCE_AUTO_VOICE = "sentence_auto_voice"
    static let SHOULD_NOTIFY = "should_notify"
    static let ACTIVE_TIME = "active_time"
    static let SYNC_TIME = "sync_time"
    static let WRONG_WORD_POST_TIME = "wrong_word_post_time"
    static let LAST_LOGIN_AT = "last_login_at"
    
    static let GUIDE_HAVE_TO_PAGE_CHINESE = "guide_have_to_page_chinese"
    static let GUIDE_HAVE_CLICKED_WORD = "guide_have_clicked_word"
    static let GUIDE_HAVE_SLIDE_DOWN_TO_SEE_SENTENCE = "have_slide_down_to_see_sentence"
    static let GUIDE_HAVE_SWIPE_ON_SENTENCE = "have_swipe_on_sentence"
}