"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserValidation = void 0;
const zod_1 = require("zod");
// Allowed enums (must match interface)
const experienceLevels = ['Fresher', 'Junior', 'Mid', 'Senior'];
const careerTracks = [
    'Web Development',
    'Data',
    'Design',
    'Marketing',
    'Cybersecurity',
    'AI/ML',
    'Mobile App',
    'Other',
];
const userRoles = ['admin', 'user'];
const createUserValidationSchema = zod_1.z.object({
    body: zod_1.z.object({
        fullName: zod_1.z.string().nonempty({ message: 'Full name is required' }),
        email: zod_1.z
            .string()
            .nonempty({ message: 'Email is required' })
            .email({ message: 'Invalid email format' }),
        password: zod_1.z
            .string()
            .nonempty({ message: 'Password is required' })
            .min(6, { message: 'Password must be at least 6 characters long' })
            .max(20, { message: 'Password cannot exceed 20 characters' }),
        educationLevel: zod_1.z
            .string()
            .nonempty({ message: 'Education level is required' }),
        department: zod_1.z.string().nonempty({ message: 'Department is required' }),
        experienceLevel: zod_1.z.enum(experienceLevels, {
            message: 'Invalid experience level',
        }),
        preferredCareerTrack: zod_1.z.enum(careerTracks, {
            message: 'Invalid career track',
        }),
        profilePic: zod_1.z.string().url().optional(),
        skills: zod_1.z.array(zod_1.z.string()).optional(),
        experienceDescription: zod_1.z.string().optional(),
        careerInterests: zod_1.z.string().optional(),
        cvText: zod_1.z.string().optional(),
        role: zod_1.z.enum(userRoles).default('user'),
        isBlocked: zod_1.z.boolean().default(false),
    }),
});
const updateUserValidationSchema = zod_1.z.object({
    body: zod_1.z.object({
        fullName: zod_1.z.string().optional(),
        email: zod_1.z.string().email({ message: 'Invalid email format' }).optional(),
        password: zod_1.z
            .string()
            .min(6, { message: 'Password must be at least 6 characters long' })
            .max(20, { message: 'Password cannot exceed 20 characters' })
            .optional(),
        educationLevel: zod_1.z.string().optional(),
        department: zod_1.z.string().optional(),
        experienceLevel: zod_1.z.enum(experienceLevels).optional(),
        preferredCareerTrack: zod_1.z.enum(careerTracks).optional(),
        profilePic: zod_1.z.string().url().optional(),
        skills: zod_1.z.array(zod_1.z.string()).optional(),
        experienceDescription: zod_1.z.string().optional(),
        careerInterests: zod_1.z.string().optional(),
        cvText: zod_1.z.string().optional(),
        role: zod_1.z.enum(userRoles).optional(),
        isBlocked: zod_1.z.boolean().optional(),
    }),
});
exports.UserValidation = {
    createUserValidationSchema,
    updateUserValidationSchema,
};
