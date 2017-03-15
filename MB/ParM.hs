{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParM where
import AbsM
import LexM
import ErrM
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn51 (Ident)
	| HappyAbsSyn52 (Integer)
	| HappyAbsSyn53 (Double)
	| HappyAbsSyn54 (Char)
	| HappyAbsSyn55 (CID)
	| HappyAbsSyn56 (BVAL)
	| HappyAbsSyn57 (Prog)
	| HappyAbsSyn58 (Block)
	| HappyAbsSyn59 (Declarations)
	| HappyAbsSyn60 (Declaration)
	| HappyAbsSyn61 (VarDeclaration)
	| HappyAbsSyn62 (VarSpecs)
	| HappyAbsSyn63 (MoreVarSpecs)
	| HappyAbsSyn64 (VarSpec)
	| HappyAbsSyn65 (ArrayDimensions)
	| HappyAbsSyn66 (Type)
	| HappyAbsSyn67 (FunDeclaration)
	| HappyAbsSyn68 (FunBlock)
	| HappyAbsSyn69 (ParamList)
	| HappyAbsSyn70 (Parameters)
	| HappyAbsSyn71 (MoreParameters)
	| HappyAbsSyn72 (BasicDeclaration)
	| HappyAbsSyn73 (BasicArrayDimensions)
	| HappyAbsSyn74 (DataDeclaration)
	| HappyAbsSyn75 (ConsDeclarations)
	| HappyAbsSyn76 (MoreConsDecl)
	| HappyAbsSyn77 (ConsDecl)
	| HappyAbsSyn78 (TypeList)
	| HappyAbsSyn79 (MoreType)
	| HappyAbsSyn80 (ProgramBody)
	| HappyAbsSyn81 (FunBody)
	| HappyAbsSyn82 (ProgStmts)
	| HappyAbsSyn83 (ProgStmt)
	| HappyAbsSyn84 (Location)
	| HappyAbsSyn85 (CaseList)
	| HappyAbsSyn86 (MoreCase)
	| HappyAbsSyn87 (Case)
	| HappyAbsSyn88 (VarList)
	| HappyAbsSyn90 (MoreVarList)
	| HappyAbsSyn91 (Expr)
	| HappyAbsSyn92 (BintTerm)
	| HappyAbsSyn93 (BintFactor)
	| HappyAbsSyn94 (CompareOp)
	| HappyAbsSyn95 (IntExpr)
	| HappyAbsSyn96 (Addop)
	| HappyAbsSyn97 (IntTerm)
	| HappyAbsSyn98 (Mulop)
	| HappyAbsSyn99 (IntFactor)
	| HappyAbsSyn100 (ModifierList)
	| HappyAbsSyn101 (FunArgumentList)
	| HappyAbsSyn102 (ConsArgumentList)
	| HappyAbsSyn103 (Arguments)
	| HappyAbsSyn104 (MoreArguments)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152,
 action_153,
 action_154,
 action_155,
 action_156,
 action_157,
 action_158,
 action_159,
 action_160,
 action_161,
 action_162,
 action_163,
 action_164,
 action_165,
 action_166,
 action_167,
 action_168,
 action_169,
 action_170,
 action_171,
 action_172,
 action_173,
 action_174,
 action_175,
 action_176,
 action_177,
 action_178,
 action_179,
 action_180,
 action_181,
 action_182,
 action_183,
 action_184,
 action_185,
 action_186,
 action_187,
 action_188,
 action_189,
 action_190,
 action_191,
 action_192,
 action_193,
 action_194,
 action_195,
 action_196,
 action_197,
 action_198,
 action_199,
 action_200,
 action_201,
 action_202,
 action_203,
 action_204,
 action_205,
 action_206,
 action_207,
 action_208,
 action_209,
 action_210,
 action_211,
 action_212,
 action_213,
 action_214,
 action_215,
 action_216,
 action_217,
 action_218,
 action_219,
 action_220,
 action_221,
 action_222,
 action_223,
 action_224,
 action_225,
 action_226,
 action_227,
 action_228,
 action_229,
 action_230,
 action_231,
 action_232,
 action_233,
 action_234,
 action_235,
 action_236,
 action_237,
 action_238,
 action_239,
 action_240,
 action_241,
 action_242,
 action_243,
 action_244,
 action_245,
 action_246,
 action_247,
 action_248,
 action_249,
 action_250,
 action_251,
 action_252,
 action_253,
 action_254,
 action_255,
 action_256,
 action_257,
 action_258,
 action_259,
 action_260,
 action_261,
 action_262,
 action_263,
 action_264,
 action_265,
 action_266,
 action_267,
 action_268,
 action_269,
 action_270,
 action_271,
 action_272,
 action_273,
 action_274,
 action_275,
 action_276,
 action_277,
 action_278,
 action_279,
 action_280,
 action_281,
 action_282,
 action_283,
 action_284,
 action_285,
 action_286,
 action_287,
 action_288,
 action_289,
 action_290,
 action_291,
 action_292,
 action_293,
 action_294,
 action_295,
 action_296,
 action_297,
 action_298,
 action_299,
 action_300,
 action_301,
 action_302 :: () => Int -> ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83,
 happyReduce_84,
 happyReduce_85,
 happyReduce_86,
 happyReduce_87,
 happyReduce_88,
 happyReduce_89,
 happyReduce_90,
 happyReduce_91,
 happyReduce_92,
 happyReduce_93,
 happyReduce_94,
 happyReduce_95,
 happyReduce_96,
 happyReduce_97,
 happyReduce_98,
 happyReduce_99,
 happyReduce_100,
 happyReduce_101,
 happyReduce_102,
 happyReduce_103,
 happyReduce_104,
 happyReduce_105,
 happyReduce_106,
 happyReduce_107,
 happyReduce_108,
 happyReduce_109,
 happyReduce_110,
 happyReduce_111,
 happyReduce_112,
 happyReduce_113,
 happyReduce_114,
 happyReduce_115,
 happyReduce_116,
 happyReduce_117,
 happyReduce_118,
 happyReduce_119,
 happyReduce_120,
 happyReduce_121,
 happyReduce_122,
 happyReduce_123,
 happyReduce_124,
 happyReduce_125,
 happyReduce_126,
 happyReduce_127,
 happyReduce_128,
 happyReduce_129,
 happyReduce_130,
 happyReduce_131,
 happyReduce_132,
 happyReduce_133,
 happyReduce_134,
 happyReduce_135,
 happyReduce_136,
 happyReduce_137,
 happyReduce_138,
 happyReduce_139,
 happyReduce_140,
 happyReduce_141,
 happyReduce_142,
 happyReduce_143,
 happyReduce_144,
 happyReduce_145,
 happyReduce_146,
 happyReduce_147,
 happyReduce_148,
 happyReduce_149,
 happyReduce_150,
 happyReduce_151,
 happyReduce_152,
 happyReduce_153,
 happyReduce_154,
 happyReduce_155 :: () => ({-HappyReduction (Err) = -}
	   Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

action_0 (129) = happyShift action_149
action_0 (135) = happyShift action_166
action_0 (146) = happyShift action_167
action_0 (57) = happyGoto action_182
action_0 (58) = happyGoto action_183
action_0 (59) = happyGoto action_181
action_0 (60) = happyGoto action_161
action_0 (61) = happyGoto action_162
action_0 (67) = happyGoto action_163
action_0 (74) = happyGoto action_165
action_0 _ = happyReduce_57

action_1 (129) = happyShift action_149
action_1 (135) = happyShift action_166
action_1 (146) = happyShift action_167
action_1 (58) = happyGoto action_180
action_1 (59) = happyGoto action_181
action_1 (60) = happyGoto action_161
action_1 (61) = happyGoto action_162
action_1 (67) = happyGoto action_163
action_1 (74) = happyGoto action_165
action_1 _ = happyReduce_57

action_2 (129) = happyShift action_149
action_2 (135) = happyShift action_166
action_2 (146) = happyShift action_167
action_2 (59) = happyGoto action_179
action_2 (60) = happyGoto action_161
action_2 (61) = happyGoto action_162
action_2 (67) = happyGoto action_163
action_2 (74) = happyGoto action_165
action_2 _ = happyReduce_57

action_3 (129) = happyShift action_149
action_3 (135) = happyShift action_166
action_3 (146) = happyShift action_167
action_3 (60) = happyGoto action_178
action_3 (61) = happyGoto action_162
action_3 (67) = happyGoto action_163
action_3 (74) = happyGoto action_165
action_3 _ = happyFail

action_4 (146) = happyShift action_167
action_4 (61) = happyGoto action_177
action_4 _ = happyFail

action_5 (152) = happyShift action_49
action_5 (51) = happyGoto action_171
action_5 (62) = happyGoto action_175
action_5 (64) = happyGoto action_176
action_5 _ = happyFail

action_6 (110) = happyShift action_174
action_6 (63) = happyGoto action_173
action_6 _ = happyReduce_64

action_7 (152) = happyShift action_49
action_7 (51) = happyGoto action_171
action_7 (64) = happyGoto action_172
action_7 _ = happyFail

action_8 (122) = happyShift action_84
action_8 (65) = happyGoto action_170
action_8 _ = happyReduce_67

action_9 (125) = happyShift action_138
action_9 (128) = happyShift action_139
action_9 (137) = happyShift action_140
action_9 (142) = happyShift action_141
action_9 (152) = happyShift action_49
action_9 (51) = happyGoto action_135
action_9 (66) = happyGoto action_169
action_9 _ = happyFail

action_10 (135) = happyShift action_166
action_10 (67) = happyGoto action_168
action_10 _ = happyFail

action_11 (129) = happyShift action_149
action_11 (135) = happyShift action_166
action_11 (146) = happyShift action_167
action_11 (59) = happyGoto action_160
action_11 (60) = happyGoto action_161
action_11 (61) = happyGoto action_162
action_11 (67) = happyGoto action_163
action_11 (68) = happyGoto action_164
action_11 (74) = happyGoto action_165
action_11 _ = happyReduce_57

action_12 (106) = happyShift action_159
action_12 (69) = happyGoto action_158
action_12 _ = happyFail

action_13 (152) = happyShift action_49
action_13 (51) = happyGoto action_152
action_13 (70) = happyGoto action_156
action_13 (72) = happyGoto action_157
action_13 _ = happyReduce_77

action_14 (110) = happyShift action_155
action_14 (71) = happyGoto action_154
action_14 _ = happyReduce_79

action_15 (152) = happyShift action_49
action_15 (51) = happyGoto action_152
action_15 (72) = happyGoto action_153
action_15 _ = happyFail

action_16 (122) = happyShift action_151
action_16 (73) = happyGoto action_150
action_16 _ = happyReduce_82

action_17 (129) = happyShift action_149
action_17 (74) = happyGoto action_148
action_17 _ = happyFail

action_18 (156) = happyShift action_75
action_18 (55) = happyGoto action_142
action_18 (75) = happyGoto action_146
action_18 (77) = happyGoto action_147
action_18 _ = happyFail

action_19 (149) = happyShift action_145
action_19 (76) = happyGoto action_144
action_19 _ = happyReduce_86

action_20 (156) = happyShift action_75
action_20 (55) = happyGoto action_142
action_20 (77) = happyGoto action_143
action_20 _ = happyFail

action_21 (125) = happyShift action_138
action_21 (128) = happyShift action_139
action_21 (137) = happyShift action_140
action_21 (142) = happyShift action_141
action_21 (152) = happyShift action_49
action_21 (51) = happyGoto action_135
action_21 (66) = happyGoto action_136
action_21 (78) = happyGoto action_137
action_21 _ = happyFail

action_22 (108) = happyShift action_134
action_22 (79) = happyGoto action_133
action_22 _ = happyReduce_91

action_23 (124) = happyShift action_132
action_23 (126) = happyShift action_119
action_23 (136) = happyShift action_120
action_23 (140) = happyShift action_121
action_23 (141) = happyShift action_122
action_23 (147) = happyShift action_123
action_23 (148) = happyShift action_124
action_23 (152) = happyShift action_49
action_23 (51) = happyGoto action_115
action_23 (80) = happyGoto action_130
action_23 (82) = happyGoto action_131
action_23 (83) = happyGoto action_126
action_23 (84) = happyGoto action_118
action_23 _ = happyReduce_97

action_24 (124) = happyShift action_129
action_24 (126) = happyShift action_119
action_24 (136) = happyShift action_120
action_24 (140) = happyShift action_121
action_24 (141) = happyShift action_122
action_24 (147) = happyShift action_123
action_24 (148) = happyShift action_124
action_24 (152) = happyShift action_49
action_24 (51) = happyGoto action_115
action_24 (81) = happyGoto action_127
action_24 (82) = happyGoto action_128
action_24 (83) = happyGoto action_126
action_24 (84) = happyGoto action_118
action_24 _ = happyReduce_97

action_25 (126) = happyShift action_119
action_25 (136) = happyShift action_120
action_25 (140) = happyShift action_121
action_25 (141) = happyShift action_122
action_25 (147) = happyShift action_123
action_25 (148) = happyShift action_124
action_25 (152) = happyShift action_49
action_25 (51) = happyGoto action_115
action_25 (82) = happyGoto action_125
action_25 (83) = happyGoto action_126
action_25 (84) = happyGoto action_118
action_25 _ = happyReduce_97

action_26 (126) = happyShift action_119
action_26 (136) = happyShift action_120
action_26 (140) = happyShift action_121
action_26 (141) = happyShift action_122
action_26 (147) = happyShift action_123
action_26 (148) = happyShift action_124
action_26 (152) = happyShift action_49
action_26 (51) = happyGoto action_115
action_26 (83) = happyGoto action_117
action_26 (84) = happyGoto action_118
action_26 _ = happyFail

action_27 (152) = happyShift action_49
action_27 (51) = happyGoto action_115
action_27 (84) = happyGoto action_116
action_27 _ = happyFail

action_28 (156) = happyShift action_75
action_28 (55) = happyGoto action_109
action_28 (85) = happyGoto action_113
action_28 (87) = happyGoto action_114
action_28 _ = happyFail

action_29 (149) = happyShift action_112
action_29 (86) = happyGoto action_111
action_29 _ = happyReduce_108

action_30 (156) = happyShift action_75
action_30 (55) = happyGoto action_109
action_30 (87) = happyGoto action_110
action_30 _ = happyFail

action_31 (106) = happyShift action_108
action_31 (88) = happyGoto action_107
action_31 _ = happyReduce_111

action_32 (152) = happyShift action_49
action_32 (51) = happyGoto action_105
action_32 (89) = happyGoto action_106
action_32 _ = happyFail

action_33 (110) = happyShift action_104
action_33 (90) = happyGoto action_103
action_33 _ = happyReduce_114

action_34 (106) = happyShift action_65
action_34 (111) = happyShift action_66
action_34 (127) = happyShift action_67
action_34 (133) = happyShift action_68
action_34 (134) = happyShift action_69
action_34 (138) = happyShift action_70
action_34 (144) = happyShift action_71
action_34 (152) = happyShift action_49
action_34 (153) = happyShift action_72
action_34 (154) = happyShift action_73
action_34 (155) = happyShift action_74
action_34 (156) = happyShift action_75
action_34 (157) = happyShift action_76
action_34 (51) = happyGoto action_52
action_34 (52) = happyGoto action_53
action_34 (53) = happyGoto action_54
action_34 (54) = happyGoto action_55
action_34 (55) = happyGoto action_56
action_34 (56) = happyGoto action_57
action_34 (91) = happyGoto action_102
action_34 (92) = happyGoto action_59
action_34 (93) = happyGoto action_60
action_34 (95) = happyGoto action_61
action_34 (97) = happyGoto action_62
action_34 (99) = happyGoto action_63
action_34 _ = happyFail

action_35 (106) = happyShift action_65
action_35 (111) = happyShift action_66
action_35 (127) = happyShift action_67
action_35 (133) = happyShift action_68
action_35 (134) = happyShift action_69
action_35 (138) = happyShift action_70
action_35 (144) = happyShift action_71
action_35 (152) = happyShift action_49
action_35 (153) = happyShift action_72
action_35 (154) = happyShift action_73
action_35 (155) = happyShift action_74
action_35 (156) = happyShift action_75
action_35 (157) = happyShift action_76
action_35 (51) = happyGoto action_52
action_35 (52) = happyGoto action_53
action_35 (53) = happyGoto action_54
action_35 (54) = happyGoto action_55
action_35 (55) = happyGoto action_56
action_35 (56) = happyGoto action_57
action_35 (92) = happyGoto action_101
action_35 (93) = happyGoto action_60
action_35 (95) = happyGoto action_61
action_35 (97) = happyGoto action_62
action_35 (99) = happyGoto action_63
action_35 _ = happyFail

action_36 (106) = happyShift action_65
action_36 (111) = happyShift action_66
action_36 (127) = happyShift action_67
action_36 (133) = happyShift action_68
action_36 (134) = happyShift action_69
action_36 (138) = happyShift action_70
action_36 (144) = happyShift action_71
action_36 (152) = happyShift action_49
action_36 (153) = happyShift action_72
action_36 (154) = happyShift action_73
action_36 (155) = happyShift action_74
action_36 (156) = happyShift action_75
action_36 (157) = happyShift action_76
action_36 (51) = happyGoto action_52
action_36 (52) = happyGoto action_53
action_36 (53) = happyGoto action_54
action_36 (54) = happyGoto action_55
action_36 (55) = happyGoto action_56
action_36 (56) = happyGoto action_57
action_36 (93) = happyGoto action_100
action_36 (95) = happyGoto action_61
action_36 (97) = happyGoto action_62
action_36 (99) = happyGoto action_63
action_36 _ = happyFail

action_37 (116) = happyShift action_95
action_37 (117) = happyShift action_96
action_37 (118) = happyShift action_97
action_37 (120) = happyShift action_98
action_37 (121) = happyShift action_99
action_37 (94) = happyGoto action_94
action_37 _ = happyFail

action_38 (106) = happyShift action_65
action_38 (111) = happyShift action_66
action_38 (127) = happyShift action_67
action_38 (133) = happyShift action_68
action_38 (134) = happyShift action_69
action_38 (144) = happyShift action_71
action_38 (152) = happyShift action_49
action_38 (153) = happyShift action_72
action_38 (154) = happyShift action_73
action_38 (155) = happyShift action_74
action_38 (156) = happyShift action_75
action_38 (157) = happyShift action_76
action_38 (51) = happyGoto action_52
action_38 (52) = happyGoto action_53
action_38 (53) = happyGoto action_54
action_38 (54) = happyGoto action_55
action_38 (55) = happyGoto action_56
action_38 (56) = happyGoto action_57
action_38 (95) = happyGoto action_93
action_38 (97) = happyGoto action_62
action_38 (99) = happyGoto action_63
action_38 _ = happyFail

action_39 (109) = happyShift action_91
action_39 (111) = happyShift action_92
action_39 (96) = happyGoto action_90
action_39 _ = happyFail

action_40 (106) = happyShift action_65
action_40 (111) = happyShift action_66
action_40 (127) = happyShift action_67
action_40 (133) = happyShift action_68
action_40 (134) = happyShift action_69
action_40 (144) = happyShift action_71
action_40 (152) = happyShift action_49
action_40 (153) = happyShift action_72
action_40 (154) = happyShift action_73
action_40 (155) = happyShift action_74
action_40 (156) = happyShift action_75
action_40 (157) = happyShift action_76
action_40 (51) = happyGoto action_52
action_40 (52) = happyGoto action_53
action_40 (53) = happyGoto action_54
action_40 (54) = happyGoto action_55
action_40 (55) = happyGoto action_56
action_40 (56) = happyGoto action_57
action_40 (97) = happyGoto action_89
action_40 (99) = happyGoto action_63
action_40 _ = happyFail

action_41 (108) = happyShift action_87
action_41 (112) = happyShift action_88
action_41 (98) = happyGoto action_86
action_41 _ = happyFail

action_42 (106) = happyShift action_65
action_42 (111) = happyShift action_66
action_42 (127) = happyShift action_67
action_42 (133) = happyShift action_68
action_42 (134) = happyShift action_69
action_42 (144) = happyShift action_71
action_42 (152) = happyShift action_49
action_42 (153) = happyShift action_72
action_42 (154) = happyShift action_73
action_42 (155) = happyShift action_74
action_42 (156) = happyShift action_75
action_42 (157) = happyShift action_76
action_42 (51) = happyGoto action_52
action_42 (52) = happyGoto action_53
action_42 (53) = happyGoto action_54
action_42 (54) = happyGoto action_55
action_42 (55) = happyGoto action_56
action_42 (56) = happyGoto action_57
action_42 (99) = happyGoto action_85
action_42 _ = happyFail

action_43 (106) = happyShift action_79
action_43 (122) = happyShift action_84
action_43 (65) = happyGoto action_81
action_43 (100) = happyGoto action_82
action_43 (101) = happyGoto action_83
action_43 _ = happyReduce_67

action_44 (106) = happyShift action_79
action_44 (101) = happyGoto action_80
action_44 _ = happyFail

action_45 (106) = happyShift action_79
action_45 (101) = happyGoto action_77
action_45 (102) = happyGoto action_78
action_45 _ = happyReduce_151

action_46 (106) = happyShift action_65
action_46 (111) = happyShift action_66
action_46 (127) = happyShift action_67
action_46 (133) = happyShift action_68
action_46 (134) = happyShift action_69
action_46 (138) = happyShift action_70
action_46 (144) = happyShift action_71
action_46 (152) = happyShift action_49
action_46 (153) = happyShift action_72
action_46 (154) = happyShift action_73
action_46 (155) = happyShift action_74
action_46 (156) = happyShift action_75
action_46 (157) = happyShift action_76
action_46 (51) = happyGoto action_52
action_46 (52) = happyGoto action_53
action_46 (53) = happyGoto action_54
action_46 (54) = happyGoto action_55
action_46 (55) = happyGoto action_56
action_46 (56) = happyGoto action_57
action_46 (91) = happyGoto action_58
action_46 (92) = happyGoto action_59
action_46 (93) = happyGoto action_60
action_46 (95) = happyGoto action_61
action_46 (97) = happyGoto action_62
action_46 (99) = happyGoto action_63
action_46 (103) = happyGoto action_64
action_46 _ = happyReduce_153

action_47 (110) = happyShift action_51
action_47 (104) = happyGoto action_50
action_47 _ = happyReduce_155

action_48 (152) = happyShift action_49
action_48 _ = happyFail

action_49 _ = happyReduce_48

action_50 (158) = happyAccept
action_50 _ = happyFail

action_51 (106) = happyShift action_65
action_51 (111) = happyShift action_66
action_51 (127) = happyShift action_67
action_51 (133) = happyShift action_68
action_51 (134) = happyShift action_69
action_51 (138) = happyShift action_70
action_51 (144) = happyShift action_71
action_51 (152) = happyShift action_49
action_51 (153) = happyShift action_72
action_51 (154) = happyShift action_73
action_51 (155) = happyShift action_74
action_51 (156) = happyShift action_75
action_51 (157) = happyShift action_76
action_51 (51) = happyGoto action_52
action_51 (52) = happyGoto action_53
action_51 (53) = happyGoto action_54
action_51 (54) = happyGoto action_55
action_51 (55) = happyGoto action_56
action_51 (56) = happyGoto action_57
action_51 (91) = happyGoto action_238
action_51 (92) = happyGoto action_59
action_51 (93) = happyGoto action_60
action_51 (95) = happyGoto action_61
action_51 (97) = happyGoto action_62
action_51 (99) = happyGoto action_63
action_51 _ = happyFail

action_52 (106) = happyShift action_79
action_52 (122) = happyShift action_84
action_52 (65) = happyGoto action_81
action_52 (100) = happyGoto action_237
action_52 (101) = happyGoto action_83
action_52 _ = happyReduce_67

action_53 _ = happyReduce_142

action_54 _ = happyReduce_143

action_55 _ = happyReduce_145

action_56 (106) = happyShift action_79
action_56 (101) = happyGoto action_77
action_56 (102) = happyGoto action_236
action_56 _ = happyReduce_151

action_57 _ = happyReduce_144

action_58 (110) = happyShift action_51
action_58 (150) = happyShift action_221
action_58 (104) = happyGoto action_235
action_58 _ = happyReduce_155

action_59 (105) = happyShift action_222
action_59 _ = happyReduce_116

action_60 _ = happyReduce_118

action_61 (109) = happyShift action_91
action_61 (111) = happyShift action_92
action_61 (116) = happyShift action_95
action_61 (117) = happyShift action_96
action_61 (118) = happyShift action_97
action_61 (120) = happyShift action_98
action_61 (121) = happyShift action_99
action_61 (94) = happyGoto action_234
action_61 (96) = happyGoto action_223
action_61 _ = happyReduce_121

action_62 (108) = happyShift action_87
action_62 (112) = happyShift action_88
action_62 (98) = happyGoto action_224
action_62 _ = happyReduce_128

action_63 _ = happyReduce_132

action_64 (158) = happyAccept
action_64 _ = happyFail

action_65 (106) = happyShift action_65
action_65 (111) = happyShift action_66
action_65 (127) = happyShift action_67
action_65 (133) = happyShift action_68
action_65 (134) = happyShift action_69
action_65 (138) = happyShift action_70
action_65 (144) = happyShift action_71
action_65 (152) = happyShift action_49
action_65 (153) = happyShift action_72
action_65 (154) = happyShift action_73
action_65 (155) = happyShift action_74
action_65 (156) = happyShift action_75
action_65 (157) = happyShift action_76
action_65 (51) = happyGoto action_52
action_65 (52) = happyGoto action_53
action_65 (53) = happyGoto action_54
action_65 (54) = happyGoto action_55
action_65 (55) = happyGoto action_56
action_65 (56) = happyGoto action_57
action_65 (91) = happyGoto action_233
action_65 (92) = happyGoto action_59
action_65 (93) = happyGoto action_60
action_65 (95) = happyGoto action_61
action_65 (97) = happyGoto action_62
action_65 (99) = happyGoto action_63
action_65 _ = happyFail

action_66 (106) = happyShift action_65
action_66 (111) = happyShift action_66
action_66 (127) = happyShift action_67
action_66 (133) = happyShift action_68
action_66 (134) = happyShift action_69
action_66 (144) = happyShift action_71
action_66 (152) = happyShift action_49
action_66 (153) = happyShift action_72
action_66 (154) = happyShift action_73
action_66 (155) = happyShift action_74
action_66 (156) = happyShift action_75
action_66 (157) = happyShift action_76
action_66 (51) = happyGoto action_52
action_66 (52) = happyGoto action_53
action_66 (53) = happyGoto action_54
action_66 (54) = happyGoto action_55
action_66 (55) = happyGoto action_56
action_66 (56) = happyGoto action_57
action_66 (99) = happyGoto action_232
action_66 _ = happyFail

action_67 (106) = happyShift action_231
action_67 _ = happyFail

action_68 (106) = happyShift action_230
action_68 _ = happyFail

action_69 (106) = happyShift action_229
action_69 _ = happyFail

action_70 (106) = happyShift action_65
action_70 (111) = happyShift action_66
action_70 (127) = happyShift action_67
action_70 (133) = happyShift action_68
action_70 (134) = happyShift action_69
action_70 (138) = happyShift action_70
action_70 (144) = happyShift action_71
action_70 (152) = happyShift action_49
action_70 (153) = happyShift action_72
action_70 (154) = happyShift action_73
action_70 (155) = happyShift action_74
action_70 (156) = happyShift action_75
action_70 (157) = happyShift action_76
action_70 (51) = happyGoto action_52
action_70 (52) = happyGoto action_53
action_70 (53) = happyGoto action_54
action_70 (54) = happyGoto action_55
action_70 (55) = happyGoto action_56
action_70 (56) = happyGoto action_57
action_70 (93) = happyGoto action_228
action_70 (95) = happyGoto action_61
action_70 (97) = happyGoto action_62
action_70 (99) = happyGoto action_63
action_70 _ = happyFail

action_71 (106) = happyShift action_227
action_71 _ = happyFail

action_72 _ = happyReduce_49

action_73 _ = happyReduce_50

action_74 _ = happyReduce_51

action_75 _ = happyReduce_52

action_76 _ = happyReduce_53

action_77 _ = happyReduce_150

action_78 (158) = happyAccept
action_78 _ = happyFail

action_79 (106) = happyShift action_65
action_79 (111) = happyShift action_66
action_79 (127) = happyShift action_67
action_79 (133) = happyShift action_68
action_79 (134) = happyShift action_69
action_79 (138) = happyShift action_70
action_79 (144) = happyShift action_71
action_79 (152) = happyShift action_49
action_79 (153) = happyShift action_72
action_79 (154) = happyShift action_73
action_79 (155) = happyShift action_74
action_79 (156) = happyShift action_75
action_79 (157) = happyShift action_76
action_79 (51) = happyGoto action_52
action_79 (52) = happyGoto action_53
action_79 (53) = happyGoto action_54
action_79 (54) = happyGoto action_55
action_79 (55) = happyGoto action_56
action_79 (56) = happyGoto action_57
action_79 (91) = happyGoto action_58
action_79 (92) = happyGoto action_59
action_79 (93) = happyGoto action_60
action_79 (95) = happyGoto action_61
action_79 (97) = happyGoto action_62
action_79 (99) = happyGoto action_63
action_79 (103) = happyGoto action_226
action_79 _ = happyReduce_153

action_80 (158) = happyAccept
action_80 _ = happyFail

action_81 _ = happyReduce_148

action_82 (158) = happyAccept
action_82 _ = happyFail

action_83 _ = happyReduce_147

action_84 (106) = happyShift action_65
action_84 (111) = happyShift action_66
action_84 (127) = happyShift action_67
action_84 (133) = happyShift action_68
action_84 (134) = happyShift action_69
action_84 (138) = happyShift action_70
action_84 (144) = happyShift action_71
action_84 (152) = happyShift action_49
action_84 (153) = happyShift action_72
action_84 (154) = happyShift action_73
action_84 (155) = happyShift action_74
action_84 (156) = happyShift action_75
action_84 (157) = happyShift action_76
action_84 (51) = happyGoto action_52
action_84 (52) = happyGoto action_53
action_84 (53) = happyGoto action_54
action_84 (54) = happyGoto action_55
action_84 (55) = happyGoto action_56
action_84 (56) = happyGoto action_57
action_84 (91) = happyGoto action_225
action_84 (92) = happyGoto action_59
action_84 (93) = happyGoto action_60
action_84 (95) = happyGoto action_61
action_84 (97) = happyGoto action_62
action_84 (99) = happyGoto action_63
action_84 _ = happyFail

action_85 (158) = happyAccept
action_85 _ = happyFail

action_86 (158) = happyAccept
action_86 _ = happyFail

action_87 _ = happyReduce_133

action_88 _ = happyReduce_134

action_89 (108) = happyShift action_87
action_89 (112) = happyShift action_88
action_89 (158) = happyAccept
action_89 (98) = happyGoto action_224
action_89 _ = happyFail

action_90 (158) = happyAccept
action_90 _ = happyFail

action_91 _ = happyReduce_129

action_92 _ = happyReduce_130

action_93 (109) = happyShift action_91
action_93 (111) = happyShift action_92
action_93 (158) = happyAccept
action_93 (96) = happyGoto action_223
action_93 _ = happyFail

action_94 (158) = happyAccept
action_94 _ = happyFail

action_95 _ = happyReduce_123

action_96 _ = happyReduce_122

action_97 _ = happyReduce_125

action_98 _ = happyReduce_124

action_99 _ = happyReduce_126

action_100 (158) = happyAccept
action_100 _ = happyFail

action_101 (105) = happyShift action_222
action_101 (158) = happyAccept
action_101 _ = happyFail

action_102 (150) = happyShift action_221
action_102 (158) = happyAccept
action_102 _ = happyFail

action_103 (158) = happyAccept
action_103 _ = happyFail

action_104 (152) = happyShift action_49
action_104 (51) = happyGoto action_220
action_104 _ = happyFail

action_105 (110) = happyShift action_104
action_105 (90) = happyGoto action_219
action_105 _ = happyReduce_114

action_106 (158) = happyAccept
action_106 _ = happyFail

action_107 (158) = happyAccept
action_107 _ = happyFail

action_108 (152) = happyShift action_49
action_108 (51) = happyGoto action_105
action_108 (89) = happyGoto action_218
action_108 _ = happyFail

action_109 (106) = happyShift action_108
action_109 (88) = happyGoto action_217
action_109 _ = happyReduce_111

action_110 (158) = happyAccept
action_110 _ = happyFail

action_111 (158) = happyAccept
action_111 _ = happyFail

action_112 (156) = happyShift action_75
action_112 (55) = happyGoto action_109
action_112 (87) = happyGoto action_216
action_112 _ = happyFail

action_113 (158) = happyAccept
action_113 _ = happyFail

action_114 (149) = happyShift action_112
action_114 (86) = happyGoto action_215
action_114 _ = happyReduce_108

action_115 (122) = happyShift action_84
action_115 (65) = happyGoto action_214
action_115 _ = happyReduce_67

action_116 (158) = happyAccept
action_116 _ = happyFail

action_117 (158) = happyAccept
action_117 _ = happyFail

action_118 (114) = happyShift action_213
action_118 _ = happyFail

action_119 (106) = happyShift action_65
action_119 (111) = happyShift action_66
action_119 (127) = happyShift action_67
action_119 (133) = happyShift action_68
action_119 (134) = happyShift action_69
action_119 (138) = happyShift action_70
action_119 (144) = happyShift action_71
action_119 (152) = happyShift action_49
action_119 (153) = happyShift action_72
action_119 (154) = happyShift action_73
action_119 (155) = happyShift action_74
action_119 (156) = happyShift action_75
action_119 (157) = happyShift action_76
action_119 (51) = happyGoto action_52
action_119 (52) = happyGoto action_53
action_119 (53) = happyGoto action_54
action_119 (54) = happyGoto action_55
action_119 (55) = happyGoto action_56
action_119 (56) = happyGoto action_57
action_119 (91) = happyGoto action_212
action_119 (92) = happyGoto action_59
action_119 (93) = happyGoto action_60
action_119 (95) = happyGoto action_61
action_119 (97) = happyGoto action_62
action_119 (99) = happyGoto action_63
action_119 _ = happyFail

action_120 (106) = happyShift action_65
action_120 (111) = happyShift action_66
action_120 (127) = happyShift action_67
action_120 (133) = happyShift action_68
action_120 (134) = happyShift action_69
action_120 (138) = happyShift action_70
action_120 (144) = happyShift action_71
action_120 (152) = happyShift action_49
action_120 (153) = happyShift action_72
action_120 (154) = happyShift action_73
action_120 (155) = happyShift action_74
action_120 (156) = happyShift action_75
action_120 (157) = happyShift action_76
action_120 (51) = happyGoto action_52
action_120 (52) = happyGoto action_53
action_120 (53) = happyGoto action_54
action_120 (54) = happyGoto action_55
action_120 (55) = happyGoto action_56
action_120 (56) = happyGoto action_57
action_120 (91) = happyGoto action_211
action_120 (92) = happyGoto action_59
action_120 (93) = happyGoto action_60
action_120 (95) = happyGoto action_61
action_120 (97) = happyGoto action_62
action_120 (99) = happyGoto action_63
action_120 _ = happyFail

action_121 (106) = happyShift action_65
action_121 (111) = happyShift action_66
action_121 (127) = happyShift action_67
action_121 (133) = happyShift action_68
action_121 (134) = happyShift action_69
action_121 (138) = happyShift action_70
action_121 (144) = happyShift action_71
action_121 (152) = happyShift action_49
action_121 (153) = happyShift action_72
action_121 (154) = happyShift action_73
action_121 (155) = happyShift action_74
action_121 (156) = happyShift action_75
action_121 (157) = happyShift action_76
action_121 (51) = happyGoto action_52
action_121 (52) = happyGoto action_53
action_121 (53) = happyGoto action_54
action_121 (54) = happyGoto action_55
action_121 (55) = happyGoto action_56
action_121 (56) = happyGoto action_57
action_121 (91) = happyGoto action_210
action_121 (92) = happyGoto action_59
action_121 (93) = happyGoto action_60
action_121 (95) = happyGoto action_61
action_121 (97) = happyGoto action_62
action_121 (99) = happyGoto action_63
action_121 _ = happyFail

action_122 (152) = happyShift action_49
action_122 (51) = happyGoto action_115
action_122 (84) = happyGoto action_209
action_122 _ = happyFail

action_123 (106) = happyShift action_65
action_123 (111) = happyShift action_66
action_123 (127) = happyShift action_67
action_123 (133) = happyShift action_68
action_123 (134) = happyShift action_69
action_123 (138) = happyShift action_70
action_123 (144) = happyShift action_71
action_123 (152) = happyShift action_49
action_123 (153) = happyShift action_72
action_123 (154) = happyShift action_73
action_123 (155) = happyShift action_74
action_123 (156) = happyShift action_75
action_123 (157) = happyShift action_76
action_123 (51) = happyGoto action_52
action_123 (52) = happyGoto action_53
action_123 (53) = happyGoto action_54
action_123 (54) = happyGoto action_55
action_123 (55) = happyGoto action_56
action_123 (56) = happyGoto action_57
action_123 (91) = happyGoto action_208
action_123 (92) = happyGoto action_59
action_123 (93) = happyGoto action_60
action_123 (95) = happyGoto action_61
action_123 (97) = happyGoto action_62
action_123 (99) = happyGoto action_63
action_123 _ = happyFail

action_124 (129) = happyShift action_149
action_124 (135) = happyShift action_166
action_124 (146) = happyShift action_167
action_124 (58) = happyGoto action_207
action_124 (59) = happyGoto action_181
action_124 (60) = happyGoto action_161
action_124 (61) = happyGoto action_162
action_124 (67) = happyGoto action_163
action_124 (74) = happyGoto action_165
action_124 _ = happyReduce_57

action_125 (158) = happyAccept
action_125 _ = happyFail

action_126 (115) = happyShift action_206
action_126 _ = happyFail

action_127 (158) = happyAccept
action_127 _ = happyFail

action_128 (143) = happyShift action_205
action_128 _ = happyFail

action_129 (126) = happyShift action_119
action_129 (136) = happyShift action_120
action_129 (140) = happyShift action_121
action_129 (141) = happyShift action_122
action_129 (147) = happyShift action_123
action_129 (148) = happyShift action_124
action_129 (152) = happyShift action_49
action_129 (51) = happyGoto action_115
action_129 (82) = happyGoto action_204
action_129 (83) = happyGoto action_126
action_129 (84) = happyGoto action_118
action_129 _ = happyReduce_97

action_130 (158) = happyAccept
action_130 _ = happyFail

action_131 _ = happyReduce_93

action_132 (126) = happyShift action_119
action_132 (136) = happyShift action_120
action_132 (140) = happyShift action_121
action_132 (141) = happyShift action_122
action_132 (147) = happyShift action_123
action_132 (148) = happyShift action_124
action_132 (152) = happyShift action_49
action_132 (51) = happyGoto action_115
action_132 (82) = happyGoto action_203
action_132 (83) = happyGoto action_126
action_132 (84) = happyGoto action_118
action_132 _ = happyReduce_97

action_133 (158) = happyAccept
action_133 _ = happyFail

action_134 (125) = happyShift action_138
action_134 (128) = happyShift action_139
action_134 (137) = happyShift action_140
action_134 (142) = happyShift action_141
action_134 (152) = happyShift action_49
action_134 (51) = happyGoto action_135
action_134 (66) = happyGoto action_202
action_134 _ = happyFail

action_135 _ = happyReduce_72

action_136 (108) = happyShift action_134
action_136 (79) = happyGoto action_201
action_136 _ = happyReduce_91

action_137 (158) = happyAccept
action_137 _ = happyFail

action_138 _ = happyReduce_70

action_139 _ = happyReduce_71

action_140 _ = happyReduce_68

action_141 _ = happyReduce_69

action_142 (139) = happyShift action_200
action_142 _ = happyReduce_88

action_143 (158) = happyAccept
action_143 _ = happyFail

action_144 (158) = happyAccept
action_144 _ = happyFail

action_145 (156) = happyShift action_75
action_145 (55) = happyGoto action_142
action_145 (77) = happyGoto action_199
action_145 _ = happyFail

action_146 (158) = happyAccept
action_146 _ = happyFail

action_147 (149) = happyShift action_145
action_147 (76) = happyGoto action_198
action_147 _ = happyReduce_86

action_148 (158) = happyAccept
action_148 _ = happyFail

action_149 (152) = happyShift action_49
action_149 (51) = happyGoto action_197
action_149 _ = happyFail

action_150 (158) = happyAccept
action_150 _ = happyFail

action_151 (123) = happyShift action_196
action_151 _ = happyFail

action_152 (122) = happyShift action_151
action_152 (73) = happyGoto action_195
action_152 _ = happyReduce_82

action_153 (158) = happyAccept
action_153 _ = happyFail

action_154 (158) = happyAccept
action_154 _ = happyFail

action_155 (152) = happyShift action_49
action_155 (51) = happyGoto action_152
action_155 (72) = happyGoto action_194
action_155 _ = happyFail

action_156 (158) = happyAccept
action_156 _ = happyFail

action_157 (110) = happyShift action_155
action_157 (71) = happyGoto action_193
action_157 _ = happyReduce_79

action_158 (158) = happyAccept
action_158 _ = happyFail

action_159 (152) = happyShift action_49
action_159 (51) = happyGoto action_152
action_159 (70) = happyGoto action_192
action_159 (72) = happyGoto action_157
action_159 _ = happyReduce_77

action_160 (124) = happyShift action_129
action_160 (126) = happyShift action_119
action_160 (136) = happyShift action_120
action_160 (140) = happyShift action_121
action_160 (141) = happyShift action_122
action_160 (147) = happyShift action_123
action_160 (148) = happyShift action_124
action_160 (152) = happyShift action_49
action_160 (51) = happyGoto action_115
action_160 (81) = happyGoto action_191
action_160 (82) = happyGoto action_128
action_160 (83) = happyGoto action_126
action_160 (84) = happyGoto action_118
action_160 _ = happyReduce_97

action_161 (115) = happyShift action_190
action_161 _ = happyFail

action_162 _ = happyReduce_58

action_163 _ = happyReduce_59

action_164 (158) = happyAccept
action_164 _ = happyFail

action_165 _ = happyReduce_60

action_166 (152) = happyShift action_49
action_166 (51) = happyGoto action_189
action_166 _ = happyFail

action_167 (152) = happyShift action_49
action_167 (51) = happyGoto action_171
action_167 (62) = happyGoto action_188
action_167 (64) = happyGoto action_176
action_167 _ = happyFail

action_168 (158) = happyAccept
action_168 _ = happyFail

action_169 (158) = happyAccept
action_169 _ = happyFail

action_170 (158) = happyAccept
action_170 _ = happyFail

action_171 (122) = happyShift action_84
action_171 (65) = happyGoto action_187
action_171 _ = happyReduce_67

action_172 (158) = happyAccept
action_172 _ = happyFail

action_173 (158) = happyAccept
action_173 _ = happyFail

action_174 (152) = happyShift action_49
action_174 (51) = happyGoto action_171
action_174 (64) = happyGoto action_186
action_174 _ = happyFail

action_175 (158) = happyAccept
action_175 _ = happyFail

action_176 (110) = happyShift action_174
action_176 (63) = happyGoto action_185
action_176 _ = happyReduce_64

action_177 (158) = happyAccept
action_177 _ = happyFail

action_178 (158) = happyAccept
action_178 _ = happyFail

action_179 (158) = happyAccept
action_179 _ = happyFail

action_180 (158) = happyAccept
action_180 _ = happyFail

action_181 (124) = happyShift action_132
action_181 (126) = happyShift action_119
action_181 (136) = happyShift action_120
action_181 (140) = happyShift action_121
action_181 (141) = happyShift action_122
action_181 (147) = happyShift action_123
action_181 (148) = happyShift action_124
action_181 (152) = happyShift action_49
action_181 (51) = happyGoto action_115
action_181 (80) = happyGoto action_184
action_181 (82) = happyGoto action_131
action_181 (83) = happyGoto action_126
action_181 (84) = happyGoto action_118
action_181 _ = happyReduce_97

action_182 (158) = happyAccept
action_182 _ = happyFail

action_183 _ = happyReduce_54

action_184 _ = happyReduce_55

action_185 _ = happyReduce_62

action_186 (110) = happyShift action_174
action_186 (63) = happyGoto action_276
action_186 _ = happyReduce_64

action_187 _ = happyReduce_65

action_188 (113) = happyShift action_275
action_188 _ = happyFail

action_189 (106) = happyShift action_159
action_189 (69) = happyGoto action_274
action_189 _ = happyFail

action_190 (129) = happyShift action_149
action_190 (135) = happyShift action_166
action_190 (146) = happyShift action_167
action_190 (59) = happyGoto action_273
action_190 (60) = happyGoto action_161
action_190 (61) = happyGoto action_162
action_190 (67) = happyGoto action_163
action_190 (74) = happyGoto action_165
action_190 _ = happyReduce_57

action_191 _ = happyReduce_74

action_192 (107) = happyShift action_272
action_192 _ = happyFail

action_193 _ = happyReduce_76

action_194 (110) = happyShift action_155
action_194 (71) = happyGoto action_271
action_194 _ = happyReduce_79

action_195 (113) = happyShift action_270
action_195 _ = happyFail

action_196 (122) = happyShift action_151
action_196 (73) = happyGoto action_269
action_196 _ = happyReduce_82

action_197 (117) = happyShift action_268
action_197 _ = happyFail

action_198 _ = happyReduce_84

action_199 (149) = happyShift action_145
action_199 (76) = happyGoto action_267
action_199 _ = happyReduce_86

action_200 (125) = happyShift action_138
action_200 (128) = happyShift action_139
action_200 (137) = happyShift action_140
action_200 (142) = happyShift action_141
action_200 (152) = happyShift action_49
action_200 (51) = happyGoto action_135
action_200 (66) = happyGoto action_136
action_200 (78) = happyGoto action_266
action_200 _ = happyFail

action_201 _ = happyReduce_89

action_202 (108) = happyShift action_134
action_202 (79) = happyGoto action_265
action_202 _ = happyReduce_91

action_203 (132) = happyShift action_264
action_203 _ = happyFail

action_204 (143) = happyShift action_263
action_204 _ = happyFail

action_205 (106) = happyShift action_65
action_205 (111) = happyShift action_66
action_205 (127) = happyShift action_67
action_205 (133) = happyShift action_68
action_205 (134) = happyShift action_69
action_205 (138) = happyShift action_70
action_205 (144) = happyShift action_71
action_205 (152) = happyShift action_49
action_205 (153) = happyShift action_72
action_205 (154) = happyShift action_73
action_205 (155) = happyShift action_74
action_205 (156) = happyShift action_75
action_205 (157) = happyShift action_76
action_205 (51) = happyGoto action_52
action_205 (52) = happyGoto action_53
action_205 (53) = happyGoto action_54
action_205 (54) = happyGoto action_55
action_205 (55) = happyGoto action_56
action_205 (56) = happyGoto action_57
action_205 (91) = happyGoto action_262
action_205 (92) = happyGoto action_59
action_205 (93) = happyGoto action_60
action_205 (95) = happyGoto action_61
action_205 (97) = happyGoto action_62
action_205 (99) = happyGoto action_63
action_205 _ = happyFail

action_206 (126) = happyShift action_119
action_206 (136) = happyShift action_120
action_206 (140) = happyShift action_121
action_206 (141) = happyShift action_122
action_206 (147) = happyShift action_123
action_206 (148) = happyShift action_124
action_206 (152) = happyShift action_49
action_206 (51) = happyGoto action_115
action_206 (82) = happyGoto action_261
action_206 (83) = happyGoto action_126
action_206 (84) = happyGoto action_118
action_206 _ = happyReduce_97

action_207 (151) = happyShift action_260
action_207 _ = happyFail

action_208 (130) = happyShift action_259
action_208 (150) = happyShift action_221
action_208 _ = happyFail

action_209 _ = happyReduce_100

action_210 (150) = happyShift action_221
action_210 _ = happyReduce_102

action_211 (145) = happyShift action_258
action_211 (150) = happyShift action_221
action_211 _ = happyFail

action_212 (139) = happyShift action_257
action_212 (150) = happyShift action_221
action_212 _ = happyFail

action_213 (106) = happyShift action_65
action_213 (111) = happyShift action_66
action_213 (127) = happyShift action_67
action_213 (133) = happyShift action_68
action_213 (134) = happyShift action_69
action_213 (138) = happyShift action_70
action_213 (144) = happyShift action_71
action_213 (152) = happyShift action_49
action_213 (153) = happyShift action_72
action_213 (154) = happyShift action_73
action_213 (155) = happyShift action_74
action_213 (156) = happyShift action_75
action_213 (157) = happyShift action_76
action_213 (51) = happyGoto action_52
action_213 (52) = happyGoto action_53
action_213 (53) = happyGoto action_54
action_213 (54) = happyGoto action_55
action_213 (55) = happyGoto action_56
action_213 (56) = happyGoto action_57
action_213 (91) = happyGoto action_256
action_213 (92) = happyGoto action_59
action_213 (93) = happyGoto action_60
action_213 (95) = happyGoto action_61
action_213 (97) = happyGoto action_62
action_213 (99) = happyGoto action_63
action_213 _ = happyFail

action_214 _ = happyReduce_105

action_215 _ = happyReduce_106

action_216 (149) = happyShift action_112
action_216 (86) = happyGoto action_255
action_216 _ = happyReduce_108

action_217 (119) = happyShift action_254
action_217 _ = happyFail

action_218 (107) = happyShift action_253
action_218 _ = happyFail

action_219 _ = happyReduce_112

action_220 (110) = happyShift action_104
action_220 (90) = happyGoto action_252
action_220 _ = happyReduce_114

action_221 (106) = happyShift action_65
action_221 (111) = happyShift action_66
action_221 (127) = happyShift action_67
action_221 (133) = happyShift action_68
action_221 (134) = happyShift action_69
action_221 (138) = happyShift action_70
action_221 (144) = happyShift action_71
action_221 (152) = happyShift action_49
action_221 (153) = happyShift action_72
action_221 (154) = happyShift action_73
action_221 (155) = happyShift action_74
action_221 (156) = happyShift action_75
action_221 (157) = happyShift action_76
action_221 (51) = happyGoto action_52
action_221 (52) = happyGoto action_53
action_221 (53) = happyGoto action_54
action_221 (54) = happyGoto action_55
action_221 (55) = happyGoto action_56
action_221 (56) = happyGoto action_57
action_221 (92) = happyGoto action_251
action_221 (93) = happyGoto action_60
action_221 (95) = happyGoto action_61
action_221 (97) = happyGoto action_62
action_221 (99) = happyGoto action_63
action_221 _ = happyFail

action_222 (106) = happyShift action_65
action_222 (111) = happyShift action_66
action_222 (127) = happyShift action_67
action_222 (133) = happyShift action_68
action_222 (134) = happyShift action_69
action_222 (138) = happyShift action_70
action_222 (144) = happyShift action_71
action_222 (152) = happyShift action_49
action_222 (153) = happyShift action_72
action_222 (154) = happyShift action_73
action_222 (155) = happyShift action_74
action_222 (156) = happyShift action_75
action_222 (157) = happyShift action_76
action_222 (51) = happyGoto action_52
action_222 (52) = happyGoto action_53
action_222 (53) = happyGoto action_54
action_222 (54) = happyGoto action_55
action_222 (55) = happyGoto action_56
action_222 (56) = happyGoto action_57
action_222 (93) = happyGoto action_250
action_222 (95) = happyGoto action_61
action_222 (97) = happyGoto action_62
action_222 (99) = happyGoto action_63
action_222 _ = happyFail

action_223 (106) = happyShift action_65
action_223 (111) = happyShift action_66
action_223 (127) = happyShift action_67
action_223 (133) = happyShift action_68
action_223 (134) = happyShift action_69
action_223 (144) = happyShift action_71
action_223 (152) = happyShift action_49
action_223 (153) = happyShift action_72
action_223 (154) = happyShift action_73
action_223 (155) = happyShift action_74
action_223 (156) = happyShift action_75
action_223 (157) = happyShift action_76
action_223 (51) = happyGoto action_52
action_223 (52) = happyGoto action_53
action_223 (53) = happyGoto action_54
action_223 (54) = happyGoto action_55
action_223 (55) = happyGoto action_56
action_223 (56) = happyGoto action_57
action_223 (97) = happyGoto action_249
action_223 (99) = happyGoto action_63
action_223 _ = happyFail

action_224 (106) = happyShift action_65
action_224 (111) = happyShift action_66
action_224 (127) = happyShift action_67
action_224 (133) = happyShift action_68
action_224 (134) = happyShift action_69
action_224 (144) = happyShift action_71
action_224 (152) = happyShift action_49
action_224 (153) = happyShift action_72
action_224 (154) = happyShift action_73
action_224 (155) = happyShift action_74
action_224 (156) = happyShift action_75
action_224 (157) = happyShift action_76
action_224 (51) = happyGoto action_52
action_224 (52) = happyGoto action_53
action_224 (53) = happyGoto action_54
action_224 (54) = happyGoto action_55
action_224 (55) = happyGoto action_56
action_224 (56) = happyGoto action_57
action_224 (99) = happyGoto action_248
action_224 _ = happyFail

action_225 (123) = happyShift action_247
action_225 (150) = happyShift action_221
action_225 _ = happyFail

action_226 (107) = happyShift action_246
action_226 _ = happyFail

action_227 (152) = happyShift action_49
action_227 (51) = happyGoto action_245
action_227 _ = happyFail

action_228 _ = happyReduce_119

action_229 (106) = happyShift action_65
action_229 (111) = happyShift action_66
action_229 (127) = happyShift action_67
action_229 (133) = happyShift action_68
action_229 (134) = happyShift action_69
action_229 (138) = happyShift action_70
action_229 (144) = happyShift action_71
action_229 (152) = happyShift action_49
action_229 (153) = happyShift action_72
action_229 (154) = happyShift action_73
action_229 (155) = happyShift action_74
action_229 (156) = happyShift action_75
action_229 (157) = happyShift action_76
action_229 (51) = happyGoto action_52
action_229 (52) = happyGoto action_53
action_229 (53) = happyGoto action_54
action_229 (54) = happyGoto action_55
action_229 (55) = happyGoto action_56
action_229 (56) = happyGoto action_57
action_229 (91) = happyGoto action_244
action_229 (92) = happyGoto action_59
action_229 (93) = happyGoto action_60
action_229 (95) = happyGoto action_61
action_229 (97) = happyGoto action_62
action_229 (99) = happyGoto action_63
action_229 _ = happyFail

action_230 (106) = happyShift action_65
action_230 (111) = happyShift action_66
action_230 (127) = happyShift action_67
action_230 (133) = happyShift action_68
action_230 (134) = happyShift action_69
action_230 (138) = happyShift action_70
action_230 (144) = happyShift action_71
action_230 (152) = happyShift action_49
action_230 (153) = happyShift action_72
action_230 (154) = happyShift action_73
action_230 (155) = happyShift action_74
action_230 (156) = happyShift action_75
action_230 (157) = happyShift action_76
action_230 (51) = happyGoto action_52
action_230 (52) = happyGoto action_53
action_230 (53) = happyGoto action_54
action_230 (54) = happyGoto action_55
action_230 (55) = happyGoto action_56
action_230 (56) = happyGoto action_57
action_230 (91) = happyGoto action_243
action_230 (92) = happyGoto action_59
action_230 (93) = happyGoto action_60
action_230 (95) = happyGoto action_61
action_230 (97) = happyGoto action_62
action_230 (99) = happyGoto action_63
action_230 _ = happyFail

action_231 (106) = happyShift action_65
action_231 (111) = happyShift action_66
action_231 (127) = happyShift action_67
action_231 (133) = happyShift action_68
action_231 (134) = happyShift action_69
action_231 (138) = happyShift action_70
action_231 (144) = happyShift action_71
action_231 (152) = happyShift action_49
action_231 (153) = happyShift action_72
action_231 (154) = happyShift action_73
action_231 (155) = happyShift action_74
action_231 (156) = happyShift action_75
action_231 (157) = happyShift action_76
action_231 (51) = happyGoto action_52
action_231 (52) = happyGoto action_53
action_231 (53) = happyGoto action_54
action_231 (54) = happyGoto action_55
action_231 (55) = happyGoto action_56
action_231 (56) = happyGoto action_57
action_231 (91) = happyGoto action_242
action_231 (92) = happyGoto action_59
action_231 (93) = happyGoto action_60
action_231 (95) = happyGoto action_61
action_231 (97) = happyGoto action_62
action_231 (99) = happyGoto action_63
action_231 _ = happyFail

action_232 _ = happyReduce_146

action_233 (107) = happyShift action_241
action_233 (150) = happyShift action_221
action_233 _ = happyFail

action_234 (106) = happyShift action_65
action_234 (111) = happyShift action_66
action_234 (127) = happyShift action_67
action_234 (133) = happyShift action_68
action_234 (134) = happyShift action_69
action_234 (144) = happyShift action_71
action_234 (152) = happyShift action_49
action_234 (153) = happyShift action_72
action_234 (154) = happyShift action_73
action_234 (155) = happyShift action_74
action_234 (156) = happyShift action_75
action_234 (157) = happyShift action_76
action_234 (51) = happyGoto action_52
action_234 (52) = happyGoto action_53
action_234 (53) = happyGoto action_54
action_234 (54) = happyGoto action_55
action_234 (55) = happyGoto action_56
action_234 (56) = happyGoto action_57
action_234 (95) = happyGoto action_240
action_234 (97) = happyGoto action_62
action_234 (99) = happyGoto action_63
action_234 _ = happyFail

action_235 _ = happyReduce_152

action_236 _ = happyReduce_141

action_237 _ = happyReduce_140

action_238 (110) = happyShift action_51
action_238 (150) = happyShift action_221
action_238 (104) = happyGoto action_239
action_238 _ = happyReduce_155

action_239 _ = happyReduce_154

action_240 (109) = happyShift action_91
action_240 (111) = happyShift action_92
action_240 (96) = happyGoto action_223
action_240 _ = happyReduce_120

action_241 _ = happyReduce_135

action_242 (107) = happyShift action_291
action_242 (150) = happyShift action_221
action_242 _ = happyFail

action_243 (107) = happyShift action_290
action_243 (150) = happyShift action_221
action_243 _ = happyFail

action_244 (107) = happyShift action_289
action_244 (150) = happyShift action_221
action_244 _ = happyFail

action_245 (122) = happyShift action_151
action_245 (73) = happyGoto action_288
action_245 _ = happyReduce_82

action_246 _ = happyReduce_149

action_247 (122) = happyShift action_84
action_247 (65) = happyGoto action_287
action_247 _ = happyReduce_67

action_248 _ = happyReduce_131

action_249 (108) = happyShift action_87
action_249 (112) = happyShift action_88
action_249 (98) = happyGoto action_224
action_249 _ = happyReduce_127

action_250 _ = happyReduce_117

action_251 (105) = happyShift action_222
action_251 _ = happyReduce_115

action_252 _ = happyReduce_113

action_253 _ = happyReduce_110

action_254 (126) = happyShift action_119
action_254 (136) = happyShift action_120
action_254 (140) = happyShift action_121
action_254 (141) = happyShift action_122
action_254 (147) = happyShift action_123
action_254 (148) = happyShift action_124
action_254 (152) = happyShift action_49
action_254 (51) = happyGoto action_115
action_254 (83) = happyGoto action_286
action_254 (84) = happyGoto action_118
action_254 _ = happyFail

action_255 _ = happyReduce_107

action_256 (150) = happyShift action_221
action_256 _ = happyReduce_101

action_257 (148) = happyShift action_285
action_257 _ = happyFail

action_258 (126) = happyShift action_119
action_258 (136) = happyShift action_120
action_258 (140) = happyShift action_121
action_258 (141) = happyShift action_122
action_258 (147) = happyShift action_123
action_258 (148) = happyShift action_124
action_258 (152) = happyShift action_49
action_258 (51) = happyGoto action_115
action_258 (83) = happyGoto action_284
action_258 (84) = happyGoto action_118
action_258 _ = happyFail

action_259 (126) = happyShift action_119
action_259 (136) = happyShift action_120
action_259 (140) = happyShift action_121
action_259 (141) = happyShift action_122
action_259 (147) = happyShift action_123
action_259 (148) = happyShift action_124
action_259 (152) = happyShift action_49
action_259 (51) = happyGoto action_115
action_259 (83) = happyGoto action_283
action_259 (84) = happyGoto action_118
action_259 _ = happyFail

action_260 _ = happyReduce_103

action_261 _ = happyReduce_96

action_262 (115) = happyShift action_282
action_262 (150) = happyShift action_221
action_262 _ = happyFail

action_263 (106) = happyShift action_65
action_263 (111) = happyShift action_66
action_263 (127) = happyShift action_67
action_263 (133) = happyShift action_68
action_263 (134) = happyShift action_69
action_263 (138) = happyShift action_70
action_263 (144) = happyShift action_71
action_263 (152) = happyShift action_49
action_263 (153) = happyShift action_72
action_263 (154) = happyShift action_73
action_263 (155) = happyShift action_74
action_263 (156) = happyShift action_75
action_263 (157) = happyShift action_76
action_263 (51) = happyGoto action_52
action_263 (52) = happyGoto action_53
action_263 (53) = happyGoto action_54
action_263 (54) = happyGoto action_55
action_263 (55) = happyGoto action_56
action_263 (56) = happyGoto action_57
action_263 (91) = happyGoto action_281
action_263 (92) = happyGoto action_59
action_263 (93) = happyGoto action_60
action_263 (95) = happyGoto action_61
action_263 (97) = happyGoto action_62
action_263 (99) = happyGoto action_63
action_263 _ = happyFail

action_264 _ = happyReduce_92

action_265 _ = happyReduce_90

action_266 _ = happyReduce_87

action_267 _ = happyReduce_85

action_268 (156) = happyShift action_75
action_268 (55) = happyGoto action_142
action_268 (75) = happyGoto action_280
action_268 (77) = happyGoto action_147
action_268 _ = happyFail

action_269 _ = happyReduce_81

action_270 (125) = happyShift action_138
action_270 (128) = happyShift action_139
action_270 (137) = happyShift action_140
action_270 (142) = happyShift action_141
action_270 (152) = happyShift action_49
action_270 (51) = happyGoto action_135
action_270 (66) = happyGoto action_279
action_270 _ = happyFail

action_271 _ = happyReduce_78

action_272 _ = happyReduce_75

action_273 _ = happyReduce_56

action_274 (113) = happyShift action_278
action_274 _ = happyFail

action_275 (125) = happyShift action_138
action_275 (128) = happyShift action_139
action_275 (137) = happyShift action_140
action_275 (142) = happyShift action_141
action_275 (152) = happyShift action_49
action_275 (51) = happyGoto action_135
action_275 (66) = happyGoto action_277
action_275 _ = happyFail

action_276 _ = happyReduce_63

action_277 _ = happyReduce_61

action_278 (125) = happyShift action_138
action_278 (128) = happyShift action_139
action_278 (137) = happyShift action_140
action_278 (142) = happyShift action_141
action_278 (152) = happyShift action_49
action_278 (51) = happyGoto action_135
action_278 (66) = happyGoto action_296
action_278 _ = happyFail

action_279 _ = happyReduce_80

action_280 _ = happyReduce_83

action_281 (115) = happyShift action_295
action_281 (150) = happyShift action_221
action_281 _ = happyFail

action_282 _ = happyReduce_95

action_283 _ = happyReduce_99

action_284 (131) = happyShift action_294
action_284 _ = happyFail

action_285 (156) = happyShift action_75
action_285 (55) = happyGoto action_109
action_285 (85) = happyGoto action_293
action_285 (87) = happyGoto action_114
action_285 _ = happyFail

action_286 _ = happyReduce_109

action_287 _ = happyReduce_66

action_288 (107) = happyShift action_292
action_288 _ = happyFail

action_289 _ = happyReduce_138

action_290 _ = happyReduce_137

action_291 _ = happyReduce_139

action_292 _ = happyReduce_136

action_293 (151) = happyShift action_300
action_293 _ = happyFail

action_294 (126) = happyShift action_119
action_294 (136) = happyShift action_120
action_294 (140) = happyShift action_121
action_294 (141) = happyShift action_122
action_294 (147) = happyShift action_123
action_294 (148) = happyShift action_124
action_294 (152) = happyShift action_49
action_294 (51) = happyGoto action_115
action_294 (83) = happyGoto action_299
action_294 (84) = happyGoto action_118
action_294 _ = happyFail

action_295 (132) = happyShift action_298
action_295 _ = happyFail

action_296 (148) = happyShift action_297
action_296 _ = happyFail

action_297 (129) = happyShift action_149
action_297 (135) = happyShift action_166
action_297 (146) = happyShift action_167
action_297 (59) = happyGoto action_160
action_297 (60) = happyGoto action_161
action_297 (61) = happyGoto action_162
action_297 (67) = happyGoto action_163
action_297 (68) = happyGoto action_301
action_297 (74) = happyGoto action_165
action_297 _ = happyReduce_57

action_298 _ = happyReduce_94

action_299 _ = happyReduce_98

action_300 _ = happyReduce_104

action_301 (151) = happyShift action_302
action_301 _ = happyFail

action_302 _ = happyReduce_73

happyReduce_48 = happySpecReduce_1  51 happyReduction_48
happyReduction_48 (HappyTerminal (PT _ (TV happy_var_1)))
	 =  HappyAbsSyn51
		 (Ident happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  52 happyReduction_49
happyReduction_49 (HappyTerminal (PT _ (TI happy_var_1)))
	 =  HappyAbsSyn52
		 ((read ( happy_var_1)) :: Integer
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  53 happyReduction_50
happyReduction_50 (HappyTerminal (PT _ (TD happy_var_1)))
	 =  HappyAbsSyn53
		 ((read ( happy_var_1)) :: Double
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  54 happyReduction_51
happyReduction_51 (HappyTerminal (PT _ (TC happy_var_1)))
	 =  HappyAbsSyn54
		 ((read ( happy_var_1)) :: Char
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_1  55 happyReduction_52
happyReduction_52 (HappyTerminal (PT _ (T_CID happy_var_1)))
	 =  HappyAbsSyn55
		 (CID (happy_var_1)
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  56 happyReduction_53
happyReduction_53 (HappyTerminal (PT _ (T_BVAL happy_var_1)))
	 =  HappyAbsSyn56
		 (BVAL (happy_var_1)
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  57 happyReduction_54
happyReduction_54 (HappyAbsSyn58  happy_var_1)
	 =  HappyAbsSyn57
		 (AbsM.Program happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_2  58 happyReduction_55
happyReduction_55 (HappyAbsSyn80  happy_var_2)
	(HappyAbsSyn59  happy_var_1)
	 =  HappyAbsSyn58
		 (AbsM.ProgramBlock happy_var_1 happy_var_2
	)
happyReduction_55 _ _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  59 happyReduction_56
happyReduction_56 (HappyAbsSyn59  happy_var_3)
	_
	(HappyAbsSyn60  happy_var_1)
	 =  HappyAbsSyn59
		 (AbsM.Decs happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_0  59 happyReduction_57
happyReduction_57  =  HappyAbsSyn59
		 (AbsM.DecsEnd
	)

happyReduce_58 = happySpecReduce_1  60 happyReduction_58
happyReduction_58 (HappyAbsSyn61  happy_var_1)
	 =  HappyAbsSyn60
		 (AbsM.DVar happy_var_1
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  60 happyReduction_59
happyReduction_59 (HappyAbsSyn67  happy_var_1)
	 =  HappyAbsSyn60
		 (AbsM.DFun happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_1  60 happyReduction_60
happyReduction_60 (HappyAbsSyn74  happy_var_1)
	 =  HappyAbsSyn60
		 (AbsM.DData happy_var_1
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happyReduce 4 61 happyReduction_61
happyReduction_61 ((HappyAbsSyn66  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn62  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn61
		 (AbsM.VarDeclaration happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_62 = happySpecReduce_2  62 happyReduction_62
happyReduction_62 (HappyAbsSyn63  happy_var_2)
	(HappyAbsSyn64  happy_var_1)
	 =  HappyAbsSyn62
		 (AbsM.VarSpecs happy_var_1 happy_var_2
	)
happyReduction_62 _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_3  63 happyReduction_63
happyReduction_63 (HappyAbsSyn63  happy_var_3)
	(HappyAbsSyn64  happy_var_2)
	_
	 =  HappyAbsSyn63
		 (AbsM.MVSList happy_var_2 happy_var_3
	)
happyReduction_63 _ _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_0  63 happyReduction_64
happyReduction_64  =  HappyAbsSyn63
		 (AbsM.MVSEnd
	)

happyReduce_65 = happySpecReduce_2  64 happyReduction_65
happyReduction_65 (HappyAbsSyn65  happy_var_2)
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn64
		 (AbsM.VarSpec happy_var_1 happy_var_2
	)
happyReduction_65 _ _  = notHappyAtAll 

happyReduce_66 = happyReduce 4 65 happyReduction_66
happyReduction_66 ((HappyAbsSyn65  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn91  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn65
		 (AbsM.ADList happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_67 = happySpecReduce_0  65 happyReduction_67
happyReduction_67  =  HappyAbsSyn65
		 (AbsM.ADEnd
	)

happyReduce_68 = happySpecReduce_1  66 happyReduction_68
happyReduction_68 _
	 =  HappyAbsSyn66
		 (AbsM.Tint
	)

happyReduce_69 = happySpecReduce_1  66 happyReduction_69
happyReduction_69 _
	 =  HappyAbsSyn66
		 (AbsM.Treal
	)

happyReduce_70 = happySpecReduce_1  66 happyReduction_70
happyReduction_70 _
	 =  HappyAbsSyn66
		 (AbsM.Tbool
	)

happyReduce_71 = happySpecReduce_1  66 happyReduction_71
happyReduction_71 _
	 =  HappyAbsSyn66
		 (AbsM.Tchar
	)

happyReduce_72 = happySpecReduce_1  66 happyReduction_72
happyReduction_72 (HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn66
		 (AbsM.Tuser happy_var_1
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happyReduce 8 67 happyReduction_73
happyReduction_73 (_ `HappyStk`
	(HappyAbsSyn68  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn66  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn69  happy_var_3) `HappyStk`
	(HappyAbsSyn51  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn67
		 (AbsM.FunctionDec happy_var_2 happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_74 = happySpecReduce_2  68 happyReduction_74
happyReduction_74 (HappyAbsSyn81  happy_var_2)
	(HappyAbsSyn59  happy_var_1)
	 =  HappyAbsSyn68
		 (AbsM.FunctionBlock happy_var_1 happy_var_2
	)
happyReduction_74 _ _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_3  69 happyReduction_75
happyReduction_75 _
	(HappyAbsSyn70  happy_var_2)
	_
	 =  HappyAbsSyn69
		 (AbsM.ParameterList happy_var_2
	)
happyReduction_75 _ _ _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_2  70 happyReduction_76
happyReduction_76 (HappyAbsSyn71  happy_var_2)
	(HappyAbsSyn72  happy_var_1)
	 =  HappyAbsSyn70
		 (AbsM.ParametersList happy_var_1 happy_var_2
	)
happyReduction_76 _ _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_0  70 happyReduction_77
happyReduction_77  =  HappyAbsSyn70
		 (AbsM.ParametersEnd
	)

happyReduce_78 = happySpecReduce_3  71 happyReduction_78
happyReduction_78 (HappyAbsSyn71  happy_var_3)
	(HappyAbsSyn72  happy_var_2)
	_
	 =  HappyAbsSyn71
		 (AbsM.MParametersList happy_var_2 happy_var_3
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_0  71 happyReduction_79
happyReduction_79  =  HappyAbsSyn71
		 (AbsM.MParametersEnd
	)

happyReduce_80 = happyReduce 4 72 happyReduction_80
happyReduction_80 ((HappyAbsSyn66  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn73  happy_var_2) `HappyStk`
	(HappyAbsSyn51  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn72
		 (AbsM.BasicDeclaration happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_81 = happySpecReduce_3  73 happyReduction_81
happyReduction_81 (HappyAbsSyn73  happy_var_3)
	_
	_
	 =  HappyAbsSyn73
		 (AbsM.BADList happy_var_3
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_0  73 happyReduction_82
happyReduction_82  =  HappyAbsSyn73
		 (AbsM.BADEnd
	)

happyReduce_83 = happyReduce 4 74 happyReduction_83
happyReduction_83 ((HappyAbsSyn75  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn51  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn74
		 (AbsM.DataDeclaration happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_84 = happySpecReduce_2  75 happyReduction_84
happyReduction_84 (HappyAbsSyn76  happy_var_2)
	(HappyAbsSyn77  happy_var_1)
	 =  HappyAbsSyn75
		 (AbsM.ConsDeclarations happy_var_1 happy_var_2
	)
happyReduction_84 _ _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_3  76 happyReduction_85
happyReduction_85 (HappyAbsSyn76  happy_var_3)
	(HappyAbsSyn77  happy_var_2)
	_
	 =  HappyAbsSyn76
		 (AbsM.MCDList happy_var_2 happy_var_3
	)
happyReduction_85 _ _ _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_0  76 happyReduction_86
happyReduction_86  =  HappyAbsSyn76
		 (AbsM.MCDEnd
	)

happyReduce_87 = happySpecReduce_3  77 happyReduction_87
happyReduction_87 (HappyAbsSyn78  happy_var_3)
	_
	(HappyAbsSyn55  happy_var_1)
	 =  HappyAbsSyn77
		 (AbsM.CTypeList happy_var_1 happy_var_3
	)
happyReduction_87 _ _ _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_1  77 happyReduction_88
happyReduction_88 (HappyAbsSyn55  happy_var_1)
	 =  HappyAbsSyn77
		 (AbsM.CSimple happy_var_1
	)
happyReduction_88 _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_2  78 happyReduction_89
happyReduction_89 (HappyAbsSyn79  happy_var_2)
	(HappyAbsSyn66  happy_var_1)
	 =  HappyAbsSyn78
		 (AbsM.TList happy_var_1 happy_var_2
	)
happyReduction_89 _ _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_3  79 happyReduction_90
happyReduction_90 (HappyAbsSyn79  happy_var_3)
	(HappyAbsSyn66  happy_var_2)
	_
	 =  HappyAbsSyn79
		 (AbsM.MTList happy_var_2 happy_var_3
	)
happyReduction_90 _ _ _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_0  79 happyReduction_91
happyReduction_91  =  HappyAbsSyn79
		 (AbsM.MTEnd
	)

happyReduce_92 = happySpecReduce_3  80 happyReduction_92
happyReduction_92 _
	(HappyAbsSyn82  happy_var_2)
	_
	 =  HappyAbsSyn80
		 (AbsM.ProgBodyA happy_var_2
	)
happyReduction_92 _ _ _  = notHappyAtAll 

happyReduce_93 = happySpecReduce_1  80 happyReduction_93
happyReduction_93 (HappyAbsSyn82  happy_var_1)
	 =  HappyAbsSyn80
		 (AbsM.ProgBodyB happy_var_1
	)
happyReduction_93 _  = notHappyAtAll 

happyReduce_94 = happyReduce 6 81 happyReduction_94
happyReduction_94 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn91  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn82  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn81
		 (AbsM.FunBodyA happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_95 = happyReduce 4 81 happyReduction_95
happyReduction_95 (_ `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn82  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn81
		 (AbsM.FunBodyB happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_96 = happySpecReduce_3  82 happyReduction_96
happyReduction_96 (HappyAbsSyn82  happy_var_3)
	_
	(HappyAbsSyn83  happy_var_1)
	 =  HappyAbsSyn82
		 (AbsM.PSList happy_var_1 happy_var_3
	)
happyReduction_96 _ _ _  = notHappyAtAll 

happyReduce_97 = happySpecReduce_0  82 happyReduction_97
happyReduction_97  =  HappyAbsSyn82
		 (AbsM.PSEnd
	)

happyReduce_98 = happyReduce 6 83 happyReduction_98
happyReduction_98 ((HappyAbsSyn83  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn83  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn91  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn83
		 (AbsM.PIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_99 = happyReduce 4 83 happyReduction_99
happyReduction_99 ((HappyAbsSyn83  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn91  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn83
		 (AbsM.PWhile happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_100 = happySpecReduce_2  83 happyReduction_100
happyReduction_100 (HappyAbsSyn84  happy_var_2)
	_
	 =  HappyAbsSyn83
		 (AbsM.PRead happy_var_2
	)
happyReduction_100 _ _  = notHappyAtAll 

happyReduce_101 = happySpecReduce_3  83 happyReduction_101
happyReduction_101 (HappyAbsSyn91  happy_var_3)
	_
	(HappyAbsSyn84  happy_var_1)
	 =  HappyAbsSyn83
		 (AbsM.PLocation happy_var_1 happy_var_3
	)
happyReduction_101 _ _ _  = notHappyAtAll 

happyReduce_102 = happySpecReduce_2  83 happyReduction_102
happyReduction_102 (HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn83
		 (AbsM.PPrint happy_var_2
	)
happyReduction_102 _ _  = notHappyAtAll 

happyReduce_103 = happySpecReduce_3  83 happyReduction_103
happyReduction_103 _
	(HappyAbsSyn58  happy_var_2)
	_
	 =  HappyAbsSyn83
		 (AbsM.PBlock happy_var_2
	)
happyReduction_103 _ _ _  = notHappyAtAll 

happyReduce_104 = happyReduce 6 83 happyReduction_104
happyReduction_104 (_ `HappyStk`
	(HappyAbsSyn85  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn91  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn83
		 (AbsM.PExpr happy_var_2 happy_var_5
	) `HappyStk` happyRest

happyReduce_105 = happySpecReduce_2  84 happyReduction_105
happyReduction_105 (HappyAbsSyn65  happy_var_2)
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn84
		 (AbsM.Location happy_var_1 happy_var_2
	)
happyReduction_105 _ _  = notHappyAtAll 

happyReduce_106 = happySpecReduce_2  85 happyReduction_106
happyReduction_106 (HappyAbsSyn86  happy_var_2)
	(HappyAbsSyn87  happy_var_1)
	 =  HappyAbsSyn85
		 (AbsM.Cases happy_var_1 happy_var_2
	)
happyReduction_106 _ _  = notHappyAtAll 

happyReduce_107 = happySpecReduce_3  86 happyReduction_107
happyReduction_107 (HappyAbsSyn86  happy_var_3)
	(HappyAbsSyn87  happy_var_2)
	_
	 =  HappyAbsSyn86
		 (AbsM.MCList happy_var_2 happy_var_3
	)
happyReduction_107 _ _ _  = notHappyAtAll 

happyReduce_108 = happySpecReduce_0  86 happyReduction_108
happyReduction_108  =  HappyAbsSyn86
		 (AbsM.MCEnd
	)

happyReduce_109 = happyReduce 4 87 happyReduction_109
happyReduction_109 ((HappyAbsSyn83  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn88  happy_var_2) `HappyStk`
	(HappyAbsSyn55  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn87
		 (AbsM.Case happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_110 = happySpecReduce_3  88 happyReduction_110
happyReduction_110 _
	(HappyAbsSyn88  happy_var_2)
	_
	 =  HappyAbsSyn88
		 (AbsM.VLList happy_var_2
	)
happyReduction_110 _ _ _  = notHappyAtAll 

happyReduce_111 = happySpecReduce_0  88 happyReduction_111
happyReduction_111  =  HappyAbsSyn88
		 (AbsM.VLEnd
	)

happyReduce_112 = happySpecReduce_2  89 happyReduction_112
happyReduction_112 (HappyAbsSyn90  happy_var_2)
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn88
		 (AbsM.VarList happy_var_1 happy_var_2
	)
happyReduction_112 _ _  = notHappyAtAll 

happyReduce_113 = happySpecReduce_3  90 happyReduction_113
happyReduction_113 (HappyAbsSyn90  happy_var_3)
	(HappyAbsSyn51  happy_var_2)
	_
	 =  HappyAbsSyn90
		 (AbsM.MVLList happy_var_2 happy_var_3
	)
happyReduction_113 _ _ _  = notHappyAtAll 

happyReduce_114 = happySpecReduce_0  90 happyReduction_114
happyReduction_114  =  HappyAbsSyn90
		 (AbsM.MVLEnd
	)

happyReduce_115 = happySpecReduce_3  91 happyReduction_115
happyReduction_115 (HappyAbsSyn92  happy_var_3)
	_
	(HappyAbsSyn91  happy_var_1)
	 =  HappyAbsSyn91
		 (AbsM.BOr happy_var_1 happy_var_3
	)
happyReduction_115 _ _ _  = notHappyAtAll 

happyReduce_116 = happySpecReduce_1  91 happyReduction_116
happyReduction_116 (HappyAbsSyn92  happy_var_1)
	 =  HappyAbsSyn91
		 (AbsM.BTerm happy_var_1
	)
happyReduction_116 _  = notHappyAtAll 

happyReduce_117 = happySpecReduce_3  92 happyReduction_117
happyReduction_117 (HappyAbsSyn93  happy_var_3)
	_
	(HappyAbsSyn92  happy_var_1)
	 =  HappyAbsSyn92
		 (AbsM.BAnd happy_var_1 happy_var_3
	)
happyReduction_117 _ _ _  = notHappyAtAll 

happyReduce_118 = happySpecReduce_1  92 happyReduction_118
happyReduction_118 (HappyAbsSyn93  happy_var_1)
	 =  HappyAbsSyn92
		 (AbsM.BFactor happy_var_1
	)
happyReduction_118 _  = notHappyAtAll 

happyReduce_119 = happySpecReduce_2  93 happyReduction_119
happyReduction_119 (HappyAbsSyn93  happy_var_2)
	_
	 =  HappyAbsSyn93
		 (AbsM.BNot happy_var_2
	)
happyReduction_119 _ _  = notHappyAtAll 

happyReduce_120 = happySpecReduce_3  93 happyReduction_120
happyReduction_120 (HappyAbsSyn95  happy_var_3)
	(HappyAbsSyn94  happy_var_2)
	(HappyAbsSyn95  happy_var_1)
	 =  HappyAbsSyn93
		 (AbsM.BCompare happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_120 _ _ _  = notHappyAtAll 

happyReduce_121 = happySpecReduce_1  93 happyReduction_121
happyReduction_121 (HappyAbsSyn95  happy_var_1)
	 =  HappyAbsSyn93
		 (AbsM.BExpr happy_var_1
	)
happyReduction_121 _  = notHappyAtAll 

happyReduce_122 = happySpecReduce_1  94 happyReduction_122
happyReduction_122 _
	 =  HappyAbsSyn94
		 (AbsM.CompEQ
	)

happyReduce_123 = happySpecReduce_1  94 happyReduction_123
happyReduction_123 _
	 =  HappyAbsSyn94
		 (AbsM.CompLT
	)

happyReduce_124 = happySpecReduce_1  94 happyReduction_124
happyReduction_124 _
	 =  HappyAbsSyn94
		 (AbsM.CompGT
	)

happyReduce_125 = happySpecReduce_1  94 happyReduction_125
happyReduction_125 _
	 =  HappyAbsSyn94
		 (AbsM.CompLEQ
	)

happyReduce_126 = happySpecReduce_1  94 happyReduction_126
happyReduction_126 _
	 =  HappyAbsSyn94
		 (AbsM.CompGEQ
	)

happyReduce_127 = happySpecReduce_3  95 happyReduction_127
happyReduction_127 (HappyAbsSyn97  happy_var_3)
	(HappyAbsSyn96  happy_var_2)
	(HappyAbsSyn95  happy_var_1)
	 =  HappyAbsSyn95
		 (AbsM.IntAdd happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_127 _ _ _  = notHappyAtAll 

happyReduce_128 = happySpecReduce_1  95 happyReduction_128
happyReduction_128 (HappyAbsSyn97  happy_var_1)
	 =  HappyAbsSyn95
		 (AbsM.IntTerm happy_var_1
	)
happyReduction_128 _  = notHappyAtAll 

happyReduce_129 = happySpecReduce_1  96 happyReduction_129
happyReduction_129 _
	 =  HappyAbsSyn96
		 (AbsM.Add
	)

happyReduce_130 = happySpecReduce_1  96 happyReduction_130
happyReduction_130 _
	 =  HappyAbsSyn96
		 (AbsM.Sub
	)

happyReduce_131 = happySpecReduce_3  97 happyReduction_131
happyReduction_131 (HappyAbsSyn99  happy_var_3)
	(HappyAbsSyn98  happy_var_2)
	(HappyAbsSyn97  happy_var_1)
	 =  HappyAbsSyn97
		 (AbsM.IntMul happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_131 _ _ _  = notHappyAtAll 

happyReduce_132 = happySpecReduce_1  97 happyReduction_132
happyReduction_132 (HappyAbsSyn99  happy_var_1)
	 =  HappyAbsSyn97
		 (AbsM.IntFactor happy_var_1
	)
happyReduction_132 _  = notHappyAtAll 

happyReduce_133 = happySpecReduce_1  98 happyReduction_133
happyReduction_133 _
	 =  HappyAbsSyn98
		 (AbsM.Mult
	)

happyReduce_134 = happySpecReduce_1  98 happyReduction_134
happyReduction_134 _
	 =  HappyAbsSyn98
		 (AbsM.Divide
	)

happyReduce_135 = happySpecReduce_3  99 happyReduction_135
happyReduction_135 _
	(HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn99
		 (AbsM.Expression happy_var_2
	)
happyReduction_135 _ _ _  = notHappyAtAll 

happyReduce_136 = happyReduce 5 99 happyReduction_136
happyReduction_136 (_ `HappyStk`
	(HappyAbsSyn73  happy_var_4) `HappyStk`
	(HappyAbsSyn51  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn99
		 (AbsM.ListSize happy_var_3 happy_var_4
	) `HappyStk` happyRest

happyReduce_137 = happyReduce 4 99 happyReduction_137
happyReduction_137 (_ `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn99
		 (AbsM.ToFloat happy_var_3
	) `HappyStk` happyRest

happyReduce_138 = happyReduce 4 99 happyReduction_138
happyReduction_138 (_ `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn99
		 (AbsM.FunFloor happy_var_3
	) `HappyStk` happyRest

happyReduce_139 = happyReduce 4 99 happyReduction_139
happyReduction_139 (_ `HappyStk`
	(HappyAbsSyn91  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn99
		 (AbsM.FunCeil happy_var_3
	) `HappyStk` happyRest

happyReduce_140 = happySpecReduce_2  99 happyReduction_140
happyReduction_140 (HappyAbsSyn100  happy_var_2)
	(HappyAbsSyn51  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.IDModList happy_var_1 happy_var_2
	)
happyReduction_140 _ _  = notHappyAtAll 

happyReduce_141 = happySpecReduce_2  99 happyReduction_141
happyReduction_141 (HappyAbsSyn102  happy_var_2)
	(HappyAbsSyn55  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.IData happy_var_1 happy_var_2
	)
happyReduction_141 _ _  = notHappyAtAll 

happyReduce_142 = happySpecReduce_1  99 happyReduction_142
happyReduction_142 (HappyAbsSyn52  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.Integer happy_var_1
	)
happyReduction_142 _  = notHappyAtAll 

happyReduce_143 = happySpecReduce_1  99 happyReduction_143
happyReduction_143 (HappyAbsSyn53  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.Real happy_var_1
	)
happyReduction_143 _  = notHappyAtAll 

happyReduce_144 = happySpecReduce_1  99 happyReduction_144
happyReduction_144 (HappyAbsSyn56  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.Boolean happy_var_1
	)
happyReduction_144 _  = notHappyAtAll 

happyReduce_145 = happySpecReduce_1  99 happyReduction_145
happyReduction_145 (HappyAbsSyn54  happy_var_1)
	 =  HappyAbsSyn99
		 (AbsM.Character happy_var_1
	)
happyReduction_145 _  = notHappyAtAll 

happyReduce_146 = happySpecReduce_2  99 happyReduction_146
happyReduction_146 (HappyAbsSyn99  happy_var_2)
	_
	 =  HappyAbsSyn99
		 (AbsM.Negate happy_var_2
	)
happyReduction_146 _ _  = notHappyAtAll 

happyReduce_147 = happySpecReduce_1  100 happyReduction_147
happyReduction_147 (HappyAbsSyn101  happy_var_1)
	 =  HappyAbsSyn100
		 (AbsM.FunctionCall happy_var_1
	)
happyReduction_147 _  = notHappyAtAll 

happyReduce_148 = happySpecReduce_1  100 happyReduction_148
happyReduction_148 (HappyAbsSyn65  happy_var_1)
	 =  HappyAbsSyn100
		 (AbsM.ArrayAccess happy_var_1
	)
happyReduction_148 _  = notHappyAtAll 

happyReduce_149 = happySpecReduce_3  101 happyReduction_149
happyReduction_149 _
	(HappyAbsSyn103  happy_var_2)
	_
	 =  HappyAbsSyn101
		 (AbsM.Args happy_var_2
	)
happyReduction_149 _ _ _  = notHappyAtAll 

happyReduce_150 = happySpecReduce_1  102 happyReduction_150
happyReduction_150 (HappyAbsSyn101  happy_var_1)
	 =  HappyAbsSyn102
		 (AbsM.DataArguments happy_var_1
	)
happyReduction_150 _  = notHappyAtAll 

happyReduce_151 = happySpecReduce_0  102 happyReduction_151
happyReduction_151  =  HappyAbsSyn102
		 (AbsM.DataArgumentsss
	)

happyReduce_152 = happySpecReduce_2  103 happyReduction_152
happyReduction_152 (HappyAbsSyn104  happy_var_2)
	(HappyAbsSyn91  happy_var_1)
	 =  HappyAbsSyn103
		 (AbsM.AList happy_var_1 happy_var_2
	)
happyReduction_152 _ _  = notHappyAtAll 

happyReduce_153 = happySpecReduce_0  103 happyReduction_153
happyReduction_153  =  HappyAbsSyn103
		 (AbsM.AEnd
	)

happyReduce_154 = happySpecReduce_3  104 happyReduction_154
happyReduction_154 (HappyAbsSyn104  happy_var_3)
	(HappyAbsSyn91  happy_var_2)
	_
	 =  HappyAbsSyn104
		 (AbsM.MAList happy_var_2 happy_var_3
	)
happyReduction_154 _ _ _  = notHappyAtAll 

happyReduce_155 = happySpecReduce_0  104 happyReduction_155
happyReduction_155  =  HappyAbsSyn104
		 (AbsM.MAEnd
	)

happyNewToken action sts stk [] =
	action 158 158 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 105;
	PT _ (TS _ 2) -> cont 106;
	PT _ (TS _ 3) -> cont 107;
	PT _ (TS _ 4) -> cont 108;
	PT _ (TS _ 5) -> cont 109;
	PT _ (TS _ 6) -> cont 110;
	PT _ (TS _ 7) -> cont 111;
	PT _ (TS _ 8) -> cont 112;
	PT _ (TS _ 9) -> cont 113;
	PT _ (TS _ 10) -> cont 114;
	PT _ (TS _ 11) -> cont 115;
	PT _ (TS _ 12) -> cont 116;
	PT _ (TS _ 13) -> cont 117;
	PT _ (TS _ 14) -> cont 118;
	PT _ (TS _ 15) -> cont 119;
	PT _ (TS _ 16) -> cont 120;
	PT _ (TS _ 17) -> cont 121;
	PT _ (TS _ 18) -> cont 122;
	PT _ (TS _ 19) -> cont 123;
	PT _ (TS _ 20) -> cont 124;
	PT _ (TS _ 21) -> cont 125;
	PT _ (TS _ 22) -> cont 126;
	PT _ (TS _ 23) -> cont 127;
	PT _ (TS _ 24) -> cont 128;
	PT _ (TS _ 25) -> cont 129;
	PT _ (TS _ 26) -> cont 130;
	PT _ (TS _ 27) -> cont 131;
	PT _ (TS _ 28) -> cont 132;
	PT _ (TS _ 29) -> cont 133;
	PT _ (TS _ 30) -> cont 134;
	PT _ (TS _ 31) -> cont 135;
	PT _ (TS _ 32) -> cont 136;
	PT _ (TS _ 33) -> cont 137;
	PT _ (TS _ 34) -> cont 138;
	PT _ (TS _ 35) -> cont 139;
	PT _ (TS _ 36) -> cont 140;
	PT _ (TS _ 37) -> cont 141;
	PT _ (TS _ 38) -> cont 142;
	PT _ (TS _ 39) -> cont 143;
	PT _ (TS _ 40) -> cont 144;
	PT _ (TS _ 41) -> cont 145;
	PT _ (TS _ 42) -> cont 146;
	PT _ (TS _ 43) -> cont 147;
	PT _ (TS _ 44) -> cont 148;
	PT _ (TS _ 45) -> cont 149;
	PT _ (TS _ 46) -> cont 150;
	PT _ (TS _ 47) -> cont 151;
	PT _ (TV happy_dollar_dollar) -> cont 152;
	PT _ (TI happy_dollar_dollar) -> cont 153;
	PT _ (TD happy_dollar_dollar) -> cont 154;
	PT _ (TC happy_dollar_dollar) -> cont 155;
	PT _ (T_CID happy_dollar_dollar) -> cont 156;
	PT _ (T_BVAL happy_dollar_dollar) -> cont 157;
	_ -> happyError' (tk:tks)
	}

happyError_ 158 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = (thenM)
happyReturn :: () => a -> Err a
happyReturn = (returnM)
happyThen1 m k tks = (thenM) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (returnM) a
happyError' :: () => [(Token)] -> Err a
happyError' = happyError

pProg tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn57 z -> happyReturn z; _other -> notHappyAtAll })

pBlock tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_1 tks) (\x -> case x of {HappyAbsSyn58 z -> happyReturn z; _other -> notHappyAtAll })

pDeclarations tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_2 tks) (\x -> case x of {HappyAbsSyn59 z -> happyReturn z; _other -> notHappyAtAll })

pDeclaration tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_3 tks) (\x -> case x of {HappyAbsSyn60 z -> happyReturn z; _other -> notHappyAtAll })

pVarDeclaration tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_4 tks) (\x -> case x of {HappyAbsSyn61 z -> happyReturn z; _other -> notHappyAtAll })

pVarSpecs tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_5 tks) (\x -> case x of {HappyAbsSyn62 z -> happyReturn z; _other -> notHappyAtAll })

pMoreVarSpecs tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_6 tks) (\x -> case x of {HappyAbsSyn63 z -> happyReturn z; _other -> notHappyAtAll })

pVarSpec tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_7 tks) (\x -> case x of {HappyAbsSyn64 z -> happyReturn z; _other -> notHappyAtAll })

pArrayDimensions tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_8 tks) (\x -> case x of {HappyAbsSyn65 z -> happyReturn z; _other -> notHappyAtAll })

pType tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_9 tks) (\x -> case x of {HappyAbsSyn66 z -> happyReturn z; _other -> notHappyAtAll })

pFunDeclaration tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_10 tks) (\x -> case x of {HappyAbsSyn67 z -> happyReturn z; _other -> notHappyAtAll })

pFunBlock tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_11 tks) (\x -> case x of {HappyAbsSyn68 z -> happyReturn z; _other -> notHappyAtAll })

pParamList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_12 tks) (\x -> case x of {HappyAbsSyn69 z -> happyReturn z; _other -> notHappyAtAll })

pParameters tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_13 tks) (\x -> case x of {HappyAbsSyn70 z -> happyReturn z; _other -> notHappyAtAll })

pMoreParameters tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_14 tks) (\x -> case x of {HappyAbsSyn71 z -> happyReturn z; _other -> notHappyAtAll })

pBasicDeclaration tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_15 tks) (\x -> case x of {HappyAbsSyn72 z -> happyReturn z; _other -> notHappyAtAll })

pBasicArrayDimensions tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_16 tks) (\x -> case x of {HappyAbsSyn73 z -> happyReturn z; _other -> notHappyAtAll })

pDataDeclaration tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_17 tks) (\x -> case x of {HappyAbsSyn74 z -> happyReturn z; _other -> notHappyAtAll })

pConsDeclarations tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_18 tks) (\x -> case x of {HappyAbsSyn75 z -> happyReturn z; _other -> notHappyAtAll })

pMoreConsDecl tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_19 tks) (\x -> case x of {HappyAbsSyn76 z -> happyReturn z; _other -> notHappyAtAll })

pConsDecl tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_20 tks) (\x -> case x of {HappyAbsSyn77 z -> happyReturn z; _other -> notHappyAtAll })

pTypeList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_21 tks) (\x -> case x of {HappyAbsSyn78 z -> happyReturn z; _other -> notHappyAtAll })

pMoreType tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_22 tks) (\x -> case x of {HappyAbsSyn79 z -> happyReturn z; _other -> notHappyAtAll })

pProgramBody tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_23 tks) (\x -> case x of {HappyAbsSyn80 z -> happyReturn z; _other -> notHappyAtAll })

pFunBody tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_24 tks) (\x -> case x of {HappyAbsSyn81 z -> happyReturn z; _other -> notHappyAtAll })

pProgStmts tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_25 tks) (\x -> case x of {HappyAbsSyn82 z -> happyReturn z; _other -> notHappyAtAll })

pProgStmt tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_26 tks) (\x -> case x of {HappyAbsSyn83 z -> happyReturn z; _other -> notHappyAtAll })

pLocation tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_27 tks) (\x -> case x of {HappyAbsSyn84 z -> happyReturn z; _other -> notHappyAtAll })

pCaseList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_28 tks) (\x -> case x of {HappyAbsSyn85 z -> happyReturn z; _other -> notHappyAtAll })

pMoreCase tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_29 tks) (\x -> case x of {HappyAbsSyn86 z -> happyReturn z; _other -> notHappyAtAll })

pCase tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_30 tks) (\x -> case x of {HappyAbsSyn87 z -> happyReturn z; _other -> notHappyAtAll })

pVarList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_31 tks) (\x -> case x of {HappyAbsSyn88 z -> happyReturn z; _other -> notHappyAtAll })

pVarList1 tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_32 tks) (\x -> case x of {HappyAbsSyn88 z -> happyReturn z; _other -> notHappyAtAll })

pMoreVarList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_33 tks) (\x -> case x of {HappyAbsSyn90 z -> happyReturn z; _other -> notHappyAtAll })

pExpr tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_34 tks) (\x -> case x of {HappyAbsSyn91 z -> happyReturn z; _other -> notHappyAtAll })

pBintTerm tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_35 tks) (\x -> case x of {HappyAbsSyn92 z -> happyReturn z; _other -> notHappyAtAll })

pBintFactor tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_36 tks) (\x -> case x of {HappyAbsSyn93 z -> happyReturn z; _other -> notHappyAtAll })

pCompareOp tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_37 tks) (\x -> case x of {HappyAbsSyn94 z -> happyReturn z; _other -> notHappyAtAll })

pIntExpr tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_38 tks) (\x -> case x of {HappyAbsSyn95 z -> happyReturn z; _other -> notHappyAtAll })

pAddop tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_39 tks) (\x -> case x of {HappyAbsSyn96 z -> happyReturn z; _other -> notHappyAtAll })

pIntTerm tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_40 tks) (\x -> case x of {HappyAbsSyn97 z -> happyReturn z; _other -> notHappyAtAll })

pMulop tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_41 tks) (\x -> case x of {HappyAbsSyn98 z -> happyReturn z; _other -> notHappyAtAll })

pIntFactor tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_42 tks) (\x -> case x of {HappyAbsSyn99 z -> happyReturn z; _other -> notHappyAtAll })

pModifierList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_43 tks) (\x -> case x of {HappyAbsSyn100 z -> happyReturn z; _other -> notHappyAtAll })

pFunArgumentList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_44 tks) (\x -> case x of {HappyAbsSyn101 z -> happyReturn z; _other -> notHappyAtAll })

pConsArgumentList tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_45 tks) (\x -> case x of {HappyAbsSyn102 z -> happyReturn z; _other -> notHappyAtAll })

pArguments tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_46 tks) (\x -> case x of {HappyAbsSyn103 z -> happyReturn z; _other -> notHappyAtAll })

pMoreArguments tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_47 tks) (\x -> case x of {HappyAbsSyn104 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
{-# LINE 1 "templates\GenericTemplate.hs" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 9 "<command-line>" #-}
{-# LINE 1 "G:\\GitHub\\haskell-platform\\build\\ghc-bindist\\local\\lib/include\\ghcversion.h" #-}

















{-# LINE 9 "<command-line>" #-}
{-# LINE 1 "C:\\Users\\randy\\AppData\\Local\\Temp\\ghc14956_0\\ghc_2.h" #-}






















































































































































{-# LINE 9 "<command-line>" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates\\GenericTemplate.hs" #-}

{-# LINE 46 "templates\\GenericTemplate.hs" #-}








{-# LINE 67 "templates\\GenericTemplate.hs" #-}

{-# LINE 77 "templates\\GenericTemplate.hs" #-}

{-# LINE 86 "templates\\GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates\\GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates\\GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 322 "templates\\GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
