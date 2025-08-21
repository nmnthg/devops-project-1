import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    message: "Hello from API!",
  });
}

export async function POST(request) {
  try {
    const body = await request.json();
    
    return NextResponse.json({
      message: "Data received successfully!",
      receivedData: body,
      timestamp: new Date().toISOString(),
      status: "success"
    });
  } catch (error) {
    return NextResponse.json(
      {
        message: "Error processing request",
        error: error.message,
        status: "error"
      },
      { status: 400 }
    );
  }
}
