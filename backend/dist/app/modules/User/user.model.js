"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = void 0;
const mongoose_1 = require("mongoose");
const bcrypt_1 = __importDefault(require("bcrypt"));
const userSchema = new mongoose_1.Schema({
    fullName: {
        type: String,
        required: [true, 'Full name is required'],
        trim: true,
    },
    email: {
        type: String,
        required: [true, 'Email is required'],
        unique: true,
        lowercase: true,
        trim: true,
    },
    password: {
        type: String,
        required: [true, 'Password is required'],
        select: false,
    },
    educationLevel: {
        type: String,
        required: [true, 'Education level is required'],
        trim: true,
    },
    department: {
        type: String,
        required: [true, 'Department is required'],
        trim: true,
    },
    experienceLevel: {
        type: String,
        enum: [
            'Fresher',
            'Junior (0-2 years)',
            'Mid-Level (2-5 years)',
            'Senior (5+ years)',
        ],
        required: [true, 'Experience level is required'],
    },
    preferredCareerTrack: {
        type: String,
        enum: [
            'Web Development',
            'Mobile Development',
            'Data Science & Analytics',
            'UI/UX Design',
            'Graphic Design',
            'Digital Marketing',
            'Content Creation',
            'Business Development',
            'Project Management',
            'HR & Recruitment',
            'Finance & Accounting',
            'Customer Support',
            'Sales',
            'Other',
        ],
        required: [true, 'Preferred career track is required'],
    },
    profilePic: {
        type: String,
        default: '/assets/default-avatar.png',
    },
    skills: {
        type: [String],
        default: [],
    },
    experienceDescription: {
        type: String,
        trim: true,
    },
    careerInterests: {
        type: String,
        trim: true,
    },
    cvText: {
        type: String,
    },
    role: {
        type: String,
        enum: ['user', 'admin'],
        default: 'user',
    },
    isBlocked: {
        type: Boolean,
        default: false,
    },
}, {
    timestamps: true,
});
// 🔐 Hash password before saving
userSchema.pre('save', function (next) {
    return __awaiter(this, void 0, void 0, function* () {
        if (!this.isModified('password'))
            return next();
        const salt = yield bcrypt_1.default.genSalt(10);
        this.password = yield bcrypt_1.default.hash(this.password, salt);
        next();
    });
});
// ✅ Static methods
userSchema.statics.isPasswordMatched = function (plainTextPassword, hashedPassword) {
    return __awaiter(this, void 0, void 0, function* () {
        return yield bcrypt_1.default.compare(plainTextPassword, hashedPassword);
    });
};
userSchema.statics.isUserBlocked = function (userEmail) {
    return __awaiter(this, void 0, void 0, function* () {
        return yield this.findOne({ email: userEmail, isBlocked: true });
    });
};
userSchema.statics.isUserExistByEmail = function (email) {
    return __awaiter(this, void 0, void 0, function* () {
        return yield this.findOne({ email }).select('+password');
    });
};
exports.User = (0, mongoose_1.model)('User', userSchema);
