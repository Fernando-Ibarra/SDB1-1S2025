import { IsEmail, IsNumber, IsPositive, IsString, IsStrongPassword, MinLength } from "class-validator";

export class CreateClientDto {
    @IsPositive()
    @IsNumber()
    nationalId: number
    
    @IsString()
    @MinLength(3)
    name: string

    @IsString()
    @MinLength(3)
    lastname: string

    @IsString()
    @IsEmail()
    email: string

    @IsString()
    @MinLength(3)
    phone: string

    @IsString()
    active: string

    @IsNumber()
    confirmed_email: number
}
